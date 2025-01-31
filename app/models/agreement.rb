class Agreement < ApplicationRecord

  include Statusable

  before_update :log_status_change, if: :will_save_change_to_status?
  after_create :set_initial_code
  before_update :set_code_on_approved

  # Método personalizado para cargar el creator
  def creator
    # Formatea el creator a 5 dígitos y busca el User correspondiente
    formatted_id = format('%05d', creator_id || 0)
    User.find_by(clave: formatted_id) # regresa el 1er registro encontrado
  end
  # Método personalizado para asignar el creator
  def creator=(user)
    # Convierte el User#clave a un valor numérico y lo asigna a creator_id
    self.creator_id = user.clave.to_i if user.is_a?(User)
  end

  # Método personalizado para cargar el requester
  def requester
    # Formatea el requester a 5 dígitos y busca el User correspondiente
    formatted_id = format('%05d', requester_id || 0)
    User.find_by(clave: formatted_id) # regresa el 1er registro encontrado
  end
  # Método personalizado para asignar el requester
  def requester=(user)
    # Convierte el User#clave a un valor numérico y lo asigna a creator_id
    self.requester_id = user.clave.to_i if user.is_a?(User)
  end

  belongs_to :agreement_type
  has_many :members, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :agreement_logs, dependent: :destroy

  # Scope para obtener solo los campos necesarios para la tabla principal
  scope :for_table, -> (user) {
    base_query = select(
      'agreements.id',
      'agreements.creator_id',
      'agreements.requester_id',
      'agreements.code',
      'agreements.title',
      'agreements.client_name',
      'agreements.status',
      'agreements.agreement_type_id',
      'agreement_types.acronym AS type_acronym',
      'agreement_types.name AS type_name'
    ).joins(:agreement_type) #.order(id: :desc)

    if user.dev?
      # todos
    elsif user.juridico?
      # juridico puede verlos todos; excepto en edicion #, statuses[:aprobado]
      base_query = base_query.where.not(status: [statuses[:pendiente]]) # Excluir :pendiente y :aprobado
    else
      # el resto puede ver donde aparece como creator, requester o como member
      #base_query = base_query.joins("LEFT JOIN members ON members.agreement_id = agreements.id")
      #          .where(
      #            "agreements.creator_id = :user_id OR agreements.requester_id = :user_id OR members.user_id = :user_id",
      #            user_id: user.id
      #          ).distinct

      # Con EXISTS es mas eficiente

      base_query = base_query.where(
        "agreements.creator_id = :user_id
          OR agreements.requester_id = :user_id
          OR EXISTS (
            SELECT 1 FROM members
            WHERE members.agreement_id = agreements.id
            AND members.user_id = :user_id
          )",
        user_id: user.id
      )

    end
  }

  # Título: Presente y con un mínimo de 100 caracteres
  validates :title, length: { minimum: 10, message: "debe tener al menos 100 caracteres" }

  # AgreementType: Presente
  validates :agreement_type, presence: { message: "debe estar presente" }

  # requester: Presente
  validates :requester_id, presence: { message: "debe estar presente" }

  # Nombre del cliente y dirección: Presente y con un mínimo de 100 caracteres
  validates :client_name, length: { minimum: 5, message: "debe tener al menos 100 caracteres" }
  validates :client_address, length: { minimum: 5, message: "debe tener al menos 100 caracteres" }

  # Objetivo, Obligaciones, Beneficios: Mínimo 400 caracteres
  validates :objective, length: { minimum: 2, message: "debe tener al menos 200 caracteres" }
  validates :obligations, length: { minimum: 4, message: "debe tener al menos 400 caracteres" }
  validates :benefits, length: { minimum: 2, message: "debe tener al menos 200 caracteres" }

  # Fechas: Todas deben estar presentes, y deben cumplir con las relaciones de orden
  validates :signature_date, presence: { message: "debe estar presente" }
  validates :start_date, presence: { message: "debe estar presente" }
  validates :end_date, presence: { message: "debe estar presente" }

  #validate :dates_are_in_correct_order

  def formatted_code
    begin
      Integer(code)
      "inicial-#{code.to_s.rjust(3, '0')}"
    rescue ArgumentError, TypeError
      code.to_s.rjust(10, '0')
    end
  end

  def is_moral_person?
    client_type == "persona_moral"
  end

  def allowed_status_changes(user)
    # Implementa la lógica para devolver los estados permitidos
    case status
    when "pendiente"
      user.creator_of?(self) || user.requester_of?(self) ? ["en_revision", "cancelado"] : []
    when "en_revision"
      user.juridico? ? ["pendiente", "aprobado", "cancelado"] : []
    when "aprobado"
      if user.juridico?
        ["pendiente", "firmado", "cancelado"]
      elsif user.creator_of?(self) || user.requester_of?(self)
        ["firmado", "cancelado"]
      else
        []
      end
    when "firmado"
      user.juridico? ? ["completo", "cancelado"] : []
    when "cancelado"
      user.juridico? ? ["pendiente"] : []
    else
      []
    end
  end

  def can_change_status?(user, new_status)
    case status
    when "pendiente"
      (user.creator_of?(self) || user.requester_of?(self)) && new_status == "en_revision"
    when "en_revision"
      user.juridico? && %w[pendiente aprobado].include?(new_status)
    when "aprobado"
      (user.creator_of?(self) || user.requester_of?(self)) && new_status == "firmado"
    when "firmado"
      user.juridico?
    else
      false
    end
  end

  def log_status_change
    if saved_changes.key?("status")
      previous_status = saved_changes["status"].first
      new_status = saved_changes["status"].last
      AgreementLog.create!(
        agreement: self,
        status: status,
        owner_id: current_user.id,
        message: "NO ENTRA AQUI ::: Status cambiado de #{previous_status} a #{new_status}.",
        by_system: true
      )
    end
  end

  # Genera un código inicial basado en el ID cuando se guarda por primera vez
  def set_initial_code
    generated_code = id.to_s #if code.blank?

    # Asigna el código al atributo `code` y guarda el cambio
    update_column(:code, generated_code)
  end

  # Genera el código completo al cambiar el estado a "aprobado"
  def set_code_on_approved
    return unless status_changed? && status == "aprobado" && (code.blank? || code.to_i == id)

    year_suffix = Time.current.year.to_s[-2..]
    acronym = agreement_type.acronym.upcase
    consecutive = next_annual_consecutive(year_suffix)

    self.code = format("%<year_suffix>s-%<acronym>s-%<consecutive>03d",
                       year_suffix: year_suffix,
                       acronym: acronym,
                       consecutive: consecutive)
  end

  # Obtiene el siguiente consecutivo para el año en curso
  def next_annual_consecutive(year_suffix)
    existing_codes = Agreement.where("code LIKE ?", "#{year_suffix}-%")
                              .pluck(:code)
                              .compact
    max_consecutive = existing_codes.map do |code|
      code.split('-').last.to_i
    end.max || 0
    max_consecutive + 1
  end

  private

  # Validación personalizada para verificar el orden de las fechas
  def dates_are_in_correct_order
    if signature_date.present? && start_date.present? && signature_date >= start_date
      errors.add(:signature_date, "debe ser anterior a la fecha de inicio")
    end
    if start_date.present? && end_date.present? && start_date >= end_date
      errors.add(:start_date, "debe ser anterior a la fecha de término")
    end
  end

end

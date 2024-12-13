class AgreementLog < ApplicationRecord

  belongs_to :agreement

  include Statusable

  after_create :send_notification

  def owner
    # Formatea el solicitante_id a 5 dígitos y busca el User correspondiente
    formatted_id = format('%05d', owner_id)
    User.find_by(clave: formatted_id) # regresa el 1er registro encontrado
  end

  # Método personalizado para asignar el user
  def owner=(user)
    # Convierte el User#clave a un valor numérico y lo asigna a user_id
    self.owner_id = user.clave.to_i if user.is_a?(User)
  end

  # Validaciones
  validates :message, presence: true

  # Turbo Streams para agregar dinámicamente logs al inicio
  after_create_commit -> { broadcast_prepend_to "agreement_logs_tbody", partial: "agreement_logs/log", locals: { log: self } }

  private

  def send_notification
    AgreementMailer.log_notification(agreement, self).deliver_later
  end

end

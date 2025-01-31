class Member < ApplicationRecord
  # Relaciones
  belongs_to :agreement

  # Validación personalizada
  # validate :single_requester_per_agreement

  # requester: 0,
  # "requester" => "Solicitante",

  # Enums
  enum profile: { technical: 1, reviewer: 2, other: 4 }
  def profile_human
    {
      "technical" => "Técnico Responsable",
      "reviewer" => "Revisor",
      "other" => "Otro"
    }[profile]
  end

  # a1 = Agreement.find(1)
  # u1 = User.find(398)
  # m1 = a1.members.new(profile: :technical)
  # m1.user = u1
  # m1.save
  # agreement = Agreement.find(1)
  # technical_members = agreement.members.technical.includes(:user)
  # technical_members.each do |member|
  #   puts member.user_member.name # Nombre del usuario asociado
  # end
  # user = User.find(1)
  # agreements = user.agreements.includes(:members)
  # agreements.each do |agreement|
  #   puts agreement.title # Título del acuerdo
  # end


  # Métodos personalizados para manejar la relación con User
  def user
    formatted_id = format('%05d', user_id)
    User.find_by(clave: formatted_id)  # regresa el 1er registro encontrado
  end

  def user=(usuario)
    # usuario para diferenciarlo de user
    self.user_id = usuario.clave.to_i if usuario.is_a?(User) # Asigna el user_id del objeto User
  end

  # Validaciones
  validates :user_id, presence: true
  # validate :user_must_be_solicitante

  private

  def deprecated_user_must_be_requester
    unless user.belongs_to_role? :requester
      errors.add("Responsable", "técnico debe tener el rol de solicitante")
    end
  end

  def deprecated_single_requester_per_agreement
    if profile == "requester" && agreement.members.where(profile: "requester").where.not(id: id).exists?
      errors.add("", "Solo puede haber un Solicitante por convenio. Si desea cambiar de Solicitante, primero elimine al anterior.")
    end
  end

end

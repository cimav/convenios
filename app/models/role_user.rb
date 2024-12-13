class RoleUser
  include ActiveModel::Model

  # Definimos los roles
  ROLES = {
    developer: [398],    # IDs de ejemplo para usuarios con rol developer
    juridico: [477, 482],         # IDs de ejemplo para usuarios con rol juridico
    director: [8],            # IDs de ejemplo para usuarios con rol director
    participante: []           # participante será el rol por defecto si no se encuentra en otro
  }.freeze

  # Método para obtener el rol de un usuario por su ID
  def self.role_for_user(user_id)
    ROLES.each do |role, ids|
      return role if ids.include?(user_id)
    end
    :participante # Devuelve participante si el ID no está en otros roles
  end

  # Método para verificar si un usuario pertenece a un rol específico
  def self.user_belongs_to_role?(user_id, role)
    ROLES[role]&.include?(user_id) || (role == :participante && role_for_user(user_id) == :participante)
  end

  <<-COMMENT

  COMMENT
end

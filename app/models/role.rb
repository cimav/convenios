# frozen_string_literal: true

class Role < ApplicationRecord
  # Validaciones
  validates :role, presence: true
  validates :user_id, presence: true, uniqueness: true

  # Método para obtener todos los usuarios de un rol específico
  def self.user_ids_for_role(role)
    where(role: role).pluck(:user_id)
  end
end
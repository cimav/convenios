class User < ApplicationRecord

  self.abstract_class = true

  # Define la tabla que usará este modelo
  self.table_name = 'no01'
  self.primary_key = 'no01_cve_emp'

  # Especifica que este modelo usa la conexión a la base de datos oracle_netmultix
  self.establish_connection :oracle_netmultix

  # Alias para cambiar los nombres de atributos
  alias_attribute :clave, :no01_cve_emp
  alias_attribute :nombre, :no01_nom_emp
  alias_attribute :status, :no01_status
  alias_attribute :email, :no01_email60
  alias_attribute :curp, :no01_curp

  # Definir el scope con alias en los campos
  # default_scope { select(:no01_cve_emp, :no01_nom_emp, :no01_email60, :no01_curp, :no01_status) }
  default_scope { select(:clave, :nombre, :status, :curp, :email).where(status: 'A', no01_regimen: 'CYT').order(:nombre) }

  scope :recent_hundred, -> { select(:clave, :nombre, :status, :curp, :email).order('no01_cve_emp': :desc).limit(200) }

  # Scope para participante, si es necesario filtrar por rol
  scope :cyt_actives, -> { select(:clave, :nombre, :status, :curp, :email).where(no01_status: 'A', no01_regimen: 'CYT').order(:nombre) }

  # attr_accessor :id
  def id # getter
    @id ||= self.clave.strip.to_i
  end

  # Sobrescribir `find` para formatear el ID al formato esperado en la base de datos
  def self.find(id)
    formatted_id = format('%05d', id) # Ajusta a 5 dígitos, ej. '00398'
    super(formatted_id)
  end

  def self.find_by(**args)
    # Si se está buscando por `id`, ajustamos el formato del ID a cinco dígitos
    if args[:id]
      args[:id] = format('%05d', args[:id].to_i) # Ajusta el `id` a un formato de 5 dígitos
    end

    # Llamamos al método `find_by` original con los argumentos modificados
    super(args)
  end


  # Deshabilita la funcionalidad de escritura en el modelo
  def readonly?
    true
  end

  # Método para obtener el rol del usuario basándose en su ID
  def role
    RoleUser.role_for_user(id)
  end

  # Método para verificar si el usuario pertenece a un rol específico
  def belongs_to_role?(role)
    RoleUser.user_belongs_to_role?(id, role)
  end

  def self.from_omniauth(auth)

    # Verifica que el dominio del correo sea `cimav.edu.mx`
    # return nil unless auth.info.email.ends_with?('@cimav.edu.mx')
    # se maneja en SessionsController

    #  Crea o busca el usuario
    where(email: auth.info.email).first_or_initialize do |user|
      user.nombre = auth.info.name
      user.email = auth.info.email
      user.save!
    end
  end

  def short_name
    account.split('.').map(&:capitalize).join(' ')
  end

  def account
    email.gsub("@cimav.edu.mx", "")
  end

  def avatar_url
    "https://cimav.edu.mx/foto/#{account}/256"
  end

  def display_name
    "#{id} - #{nombre}"
  end

  def creator_of?(agreement)
    agreement.creator_id == id
  end

  def requester_of?(agreement)
    # Member.exists?(user_id: id, agreement_id: agreement.id, profile: "requester")
    agreement.requester_id == id
  end

  def juridico?
    belongs_to_role?(:juridico)
  end

  def dev?
    belongs_to_role?(:developer)
  end

end

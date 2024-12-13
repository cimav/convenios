class Document < ApplicationRecord
  belongs_to :agreement
  has_one_attached :file

  # Constante para los tipos de documento
  DOCUMENT_TYPES = {
    1 => 'Identificación oficial vigente',
    2 => 'Comprobante de domicilio',
    3 => 'Constancia de Situación Fiscal',
    4 => 'Opinión de cumplimiento del SAT (32D)',
    5 => 'Acta Constitutiva de la Sociedad',
    6 => 'Poder del Representante Legal',
    7 => 'Comprobante de domicilio de la Sociedad',
    8 => 'Acta de nacimiento',
    9 => 'Anexo'
  }.freeze

  def document_type_name
    DOCUMENT_TYPES[document_type_id]
  end

  def file_name
    file.attached? ? file.filename.to_s : "Sin archivo"
  end

  validates :file, presence: true
  validate :validate_file_attached
  validate :validate_file_type
  validate :validate_file_size
  #validate :validate_file_name

  private

  def validate_file_attached
    errors.add("", 'Debe adjuntar un archivo.') unless file.attached?
  end

  def validate_file_type
    return unless file.attached?

    allowed_types = ['application/pdf', 'image/png', 'image/jpeg']
    unless allowed_types.include?(file.blob.content_type)
      errors.add("", 'Solo se aceptan archivos PDF, PNG y JPEG.')
    end
  end

  def validate_file_size
    return unless file.attached?

    if file.blob.byte_size > 25.megabytes
      errors.add("", 'El archivo debe ser menor a 25MB.')
    end
  end

  def validate_file_name
    if file.attached? && file.filename.to_s.match?(/\A[a-zA-Z0-9áéíóúñÁÉÍÓÚÑ\s\-_\.]+\z/)
      errors.add("",  "Solo se permiten letras, números, espacios, guiones, guiones bajos, puntos y caracteres con acento.")
    end
  end


end

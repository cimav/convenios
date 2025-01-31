module Statusable
  extend ActiveSupport::Concern

  included do
    # Define el enum status
    enum status: { pendiente: 0, en_revision: 3, aprobado: 6, firmado: 5, completo: 9, cancelado: -1 }
  end

  # agreement.aprobado?
  # agreement.status = "completo"
  # agreement.status = :completo
  # agreement.status # => "aprobado"
  # agreement = Agreement.new(status: :aprobado)
  # agreement[:status] # => 2

  # Método de Clase para obtener información del status
  class_methods do
    def status_info(status)
      {
        "pendiente" => { icon: "fas fa-clock", color: "text-yellow-500", human: "Edición",
                         hint: "Participantes pueden modificar", action: "Re-editar", tooltip: "" },
        "en_revision" => { icon: "fas fa-search", color: "text-blue-500", human: "Revisión",
                           hint: "Jurídico está examinando el convenio", action: "Revisar", tooltip: "Enviar convenio a Jurídico para su revisión" },
        "aprobado" => { icon: "fas fa-check-circle", color: "text-green-500", human: "Aprobado",
                        hint: "Solicitante debe subir documentos comprobatorios de la firma del cliente", action: "Aprobar", tooltip: "" },
        "firmado" => { icon: "fas fa-signature", color: "text-customOrange-500", human: "Firmado",
                       hint: "Jurídico formalizando convenio", action: "Firmar", tooltip: "Notificar a Juridíco de firma del cliente" },
        "completo" => { icon: "fas fa-clipboard-check", color: "text-customPurple-500", human: "Finalizado",
                        hint: "", action: "Finalizar", tooltip: "" },
        "cancelado" => { icon: "fas fa-ban", color: "text-red-500", human: "Cancelado",
                         hint: "", action: "Cancelar", tooltip: "" }
      }[status] || { icon: "fas fa-question-circle", color: "text-gray-500", human: "Desconocido",
                     hint: "", tooltip: "" }
    end
  end

  # Método de instancia
  def status_info
    self.class.status_info(status)
  end

  # Métodos de conveniencia
  def status_icon
    status_info[:icon]
  end

  def status_color
    status_info[:color]
  end

  def status_human
    status_info[:human]
  end
end

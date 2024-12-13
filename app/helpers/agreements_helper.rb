module AgreementsHelper

  def cliente_type_label(cliente_type)
    case cliente_type
    when 'persona_moral'
      'Persona moral'
    when 'persona_fisica'
      'Persona física'
    else
      'Tipo desconocido'
    end
  end

end

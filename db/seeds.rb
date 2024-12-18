# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

puts "Deleting all agreements..."
AgreementLog.destroy_all
Document.destroy_all
Member.destroy_all
Agreement.destroy_all
AgreementType.destroy_all

AgreementType.create!([
                        {
                          name: "Convenio de Confidencialidad",
                          description: "Acuerdo para proteger la información confidencial entre las partes.",
                          has_financial_terms: false,
                          acronym: "CDC"
                        },
                        {
                          name: "Convenio General de Colaboración",
                          description: "Establece los términos generales de colaboración entre el CIMAV y otra entidad.",
                          has_financial_terms: false,
                          acronym: "CGC"
                        },
                        {
                          name: "Convenio Específico de Colaboración",
                          description: "Acuerdo detallado para una colaboración específica con términos técnicos y responsabilidades definidas.",
                          has_financial_terms: true,
                          acronym: "CEC"
                        },
                        {
                          name: "Contrato de Desarrollo Tecnológico",
                          description: "Contrato para el desarrollo tecnológico, incluyendo términos técnicos y financieros.",
                          has_financial_terms: true,
                          acronym: "CDT"
                        },
                        {
                          name: "Contrato de Prestación de Servicios",
                          description: "Contrato para la prestación de servicios con términos financieros opcionales.",
                          has_financial_terms: true,
                          acronym: "CPS"
                        }
                      ])

puts "Seeding completed: 5 Agreement Types created."

# Asegúrate de que existen tipos de acuerdo para asignarlos a los registros
agreement_types = AgreementType.pluck(:id)

# Lista de nombres de empresas conocidas
companies = [
  "Soluciones Innovadoras y Personalizadas para la Optimización de Procesos Industriales en Ambientes Dinámicos",
  "Expertos en Desarrollo de Software a Medida y Consultoría Tecnológica para Empresas en Crecimiento",
  "Diseñando Espacios Sostenibles y Funcionales que Inspiran la Creatividad y el Bienestar",
  "Agencia de Marketing Digital Especializada en Posicionamiento de Marca y Generación de Leads en el Sector de la Salud",
  "Fabricantes de Productos Orgánicos y Naturales para el Cuidado Personal y la Belleza, Elaborados con Ingredientes de Origen Vegetal",
  "Consultoría en Gestión de Proyectos y Desarrollo de Negocios para Empresas del Sector Energético",
  "Plataforma de Aprendizaje en Línea que Ofrece Cursos Personalizados e Interactivos para el Desarrollo Profesional",
  "Estudio de Diseño Gráfico y Creativo Especializado en Identidad Corporativa y Material Impreso de Alta Calidad",
  "Proveedor de Soluciones Integrales para la Gestión de la Cadena de Suministro en la Industria Alimentaria",
  "Agencia de Viajes y Turismo que Organiza Experiencias Únicas y Personalizadas en Destinos Exóticos"
]
# Lista de posibles títulos de acuerdos
agreement_titles = ['Ullamco do ut exercitation dolor ad ut veniam tempor do cupidatat laborum minim sit officia in nulla qui est excepteur sunt pariatur sed ut.',
 'Eiusmod ut officia ut dolor exercitation labore est ex occaecat est nostrud aute ex aute ex labore ipsum nulla in aute id.',
 'Adipiscing aliquip consequat laborum dolore proident ut consequat exercitation sint fugiat eiusmod incididunt ut voluptate pariatur ad.',
 'Eiusmod adipiscing aliquip sit eu officia voluptate incididunt nisi consequat duis lorem sint minim esse ea nulla consequat nulla amet.',
 'Ut dolor eu officia officia qui cillum cillum laboris culpa amet nostrud officia consequat aliquip elit ullamco laboris.',
 'Mollit mollit commodo lorem sed eiusmod sit dolore sint anim ea dolore ad cillum fugiat fugiat nisi non qui ut culpa reprehenderit.',
 'Sint dolor laboris amet laboris dolore enim ea incididunt eu et officia culpa esse proident ex excepteur eiusmod velit dolor excepteur.',
 'Velit dolore id ut pariatur veniam elit enim fugiat deserunt tempor laborum sint ipsum consectetur dolor magna incididunt laboris cillum.',
 'Minim occaecat minim id laborum ut amet sed do proident ut sed sed incididunt sit culpa labore et fugiat ut duis in amet ad.',
 'Nisi et eiusmod lorem eu sint enim dolor commodo commodo eiusmod culpa lorem consectetur nostrud labore.']

lorem = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum"

# Genera 40 registros en la tabla Agreements
40.times do
  Agreement.create!(
    title: agreement_titles.sample,
    agreement_type_id: agreement_types.sample,
    creator_id: rand(1..500), # Asume que hay usuarios con IDs en este rango

    # Información general de la empresa y representante
    client_name: companies.sample,
    client_address: "Address #{rand(1..100)}, City, Country",

    witness_name: 'testtigo',
    witness_position: 'funci€øón',


    # Información adicional del acuerdo
    objective: "#{companies.sample} :: #{lorem}",
    obligations: "#{lorem}",
    benefits: "#{lorem}",

    signature_date: Date.today - rand(1..365).days,
    start_date: Date.today - rand(1..365).days,
    end_date: Date.today + rand(30..365).days,

    # Estado y control de firmas

    signed_by_cliente: [true, false].sample,
    signed_by_solicitante: [true, false].sample,
    signed_by_director: [true, false].sample
  )
end

puts "Seeded 40 Agreement records."


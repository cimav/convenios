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

AgreementType.create!([
                        {
                          name: "Convenio de Confidencialidad",
                          description: "Acuerdo para proteger la información confidencial entre las partes.",
                          has_financial_terms: false
                        },
                        {
                          name: "Convenio General de Colaboración",
                          description: "Establece los términos generales de colaboración entre el CIMAV y otra entidad.",
                          has_financial_terms: false
                        },
                        {
                          name: "Convenio Específico de Colaboración",
                          description: "Acuerdo detallado para una colaboración específica con términos técnicos y responsabilidades definidas.",
                          has_financial_terms: true
                        },
                        {
                          name: "Contrato de Desarrollo Tecnológico",
                          description: "Contrato para el desarrollo tecnológico, incluyendo términos técnicos y financieros.",
                          has_financial_terms: true
                        },
                        {
                          name: "Contrato de Prestación de Servicios",
                          description: "Contrato para la prestación de servicios con términos financieros opcionales.",
                          has_financial_terms: true
                        }
                      ])

puts "Seeding completed: 5 Agreement Types created."

# Asegúrate de que existen tipos de acuerdo para asignarlos a los registros
agreement_types = AgreementType.pluck(:id)

# Lista de nombres de empresas conocidas
companies = [
  "Google", "Amazon", "Microsoft", "Apple", "Facebook",
  "Tesla", "Coca-Cola", "Pepsi", "Samsung", "Intel",
  "IBM", "Oracle", "Netflix", "Nike", "Toyota",
  "Sony", "Huawei", "Adidas", "Uber", "Airbnb"
]

# Lista de posibles títulos de acuerdos
agreement_titles = [
  "Colaboración Estratégica en Tecnología",
  "Acuerdo de Investigación y Desarrollo",
  "Convenio de Marketing Conjunto",
  "Alianza para Innovación en Productos",
  "Acuerdo de Distribución Exclusiva",
  "Partnership para Expansión Global",
  "Convenio de Recursos Humanos",
  "Acuerdo de Financiamiento y Capital",
  "Proyecto de Sostenibilidad y Energía",
  "Colaboración en Inteligencia Artificial",
  "Acuerdo para Capacitación Técnica",
  "Asociación para Innovación en Servicios",
  "Convenio de Licencias de Software",
  "Acuerdo de Patrocinio Comercial",
  "Colaboración en Seguridad de Datos"
]

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
    objective: "Objetivo del acuerdo relacionado con #{companies.sample}",
    obligations: "Obligaciones asignadas a ambas partes",
    benefits: "Beneficios acordados mutuamente",

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


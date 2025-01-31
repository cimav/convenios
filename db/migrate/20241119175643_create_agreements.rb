class CreateAgreements < ActiveRecord::Migration[7.1]
  def change
    create_table :agreements do |t|

      t.string :title, null: false                     # Título del acuerdo

      t.references :agreement_type, null: false, foreign_key: true # Relación con AgreementType

      t.integer :creator_id                     # Creador. Referencia a Users que son no01 en NetMultix
      t.integer :requester_id                  # Solicitante. Referencia a Users que son no01 en NetMultix

      # Información general de la empresa/cliente (moral/fisico)  y representante
      # para cada convenio requerir toda la info.
      t.string :client_name, null: false                          # Nombre de la empresa/cliente
      t.string :client_address, null: false                       # Dirección de la empresa
      t.string :client_type, null: false, default: "persona_moral" # persona_fisica o persona_moral

      t.string :witness_name, null: false
      t.string :witness_position, null: false

      # Información adicional del acuerdo
      t.text :objective                               # Objeto del acuerdo
      t.text :obligations                             # Obligaciones y compromisos
      t.text :benefits                                # Beneficios acordados

      t.date :signature_date, null: false                            # Fecha de firma del acuerdo
      t.date :start_date, null: false                              # Fecha de inicio de vigencia
      t.date :end_date                                # Fecha de término de vigencia

      t.decimal :amount, precision: 10, scale: 2      # Monto total (si el acuerdo es financiero)

      # Status
      t.integer :status, default: 0                                # Estado actual del acuerdo

      # Firmas (dependientes del estado y son firmas por escito)
      t.boolean :signed_by_client, default: false     # Firmado por el cliente
      t.boolean :signed_by_requester, default: false      # Firmado por CIMAV
      t.boolean :signed_by_director, default: false      # Firmado por CIMAV

      t.timestamps
    end
  end
end

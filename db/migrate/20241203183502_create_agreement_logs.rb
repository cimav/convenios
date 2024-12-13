class CreateAgreementLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :agreement_logs do |t|
      t.references :agreement, null: false, foreign_key: true
      t.integer :owner_id # usuario que generó el log
      t.text :message
      t.integer :status, default: 0 # status del agreement
      t.boolean :by_system, default: false
      t.datetime :created_at
    end
  end
end

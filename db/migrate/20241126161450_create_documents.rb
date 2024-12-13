class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.integer :document_type_id
      t.references :agreement, null: false, foreign_key: true
      t.string :notes

      t.timestamps
    end
  end
end

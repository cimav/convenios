class CreateAgreementTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :agreement_types do |t|
      t.string :name
      t.text :description
      t.boolean :has_financial_terms

      t.timestamps
    end
  end
end

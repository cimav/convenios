class AddAcronymToAgreementTypes < ActiveRecord::Migration[7.1]
  def change
    add_column :agreement_types, :acronym, :string, limit: 5
  end
end

class AddCodeToAgreements < ActiveRecord::Migration[7.1]
  def change
    add_column :agreements, :code, :string, limit: 10
  end
end

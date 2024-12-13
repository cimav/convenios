class AddNotesToAgreement < ActiveRecord::Migration[7.1]
  def change
    add_column :agreements, :notes, :text
  end
end

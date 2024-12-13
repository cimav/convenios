class CreateMembers < ActiveRecord::Migration[7.1]
  def change
    create_table :members do |t|
      t.references :agreement, null: false, foreign_key: true
      t.integer :user_id
      t.integer :profile
      t.text :notes

      t.timestamps
    end
  end
end

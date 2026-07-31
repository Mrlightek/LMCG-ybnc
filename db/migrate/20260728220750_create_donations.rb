class CreateDonations < ActiveRecord::Migration[8.0]
  def change
    create_table :donations do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.integer :method
      t.text :note

      t.timestamps
    end
  end
end

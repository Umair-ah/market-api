class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :role
      t.string :district
      t.string :taluka
      t.boolean :verified, default: 0

      t.timestamps
    end
  end
end

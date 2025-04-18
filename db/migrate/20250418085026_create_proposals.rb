class CreateProposals < ActiveRecord::Migration[8.0]
  def change
    create_table :proposals do |t|
      t.string :title
      t.decimal :quantity
      t.string :unit
      t.decimal :price, precision: 7, scale: 2 
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

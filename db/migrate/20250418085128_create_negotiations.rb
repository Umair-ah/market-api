class CreateNegotiations < ActiveRecord::Migration[8.0]
  def change
    create_table :negotiations do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :proposal, null: false, foreign_key: true
      t.decimal :price, precision: 7, scale: 2 

      t.timestamps
    end
  end
end

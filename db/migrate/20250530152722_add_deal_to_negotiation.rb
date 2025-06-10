class AddDealToNegotiation < ActiveRecord::Migration[8.0]
  def change
    add_column :negotiations, :deal, :boolean, default: false
  end
end

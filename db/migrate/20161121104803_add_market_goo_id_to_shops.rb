class AddMarketGooIdToShops < ActiveRecord::Migration
  def change
    add_column :shops, :market_goo_id, :integer, unique: true
  end
end

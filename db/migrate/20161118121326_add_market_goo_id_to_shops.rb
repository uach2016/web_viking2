class AddMarketGooIdToShops < ActiveRecord::Migration
  def change
   add_column :shops, :market_goo_id, :string, unique: true
  end
end

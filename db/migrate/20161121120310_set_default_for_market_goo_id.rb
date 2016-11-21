class SetDefaultForMarketGooId < ActiveRecord::Migration
  def change
  	change_column :shops, :market_goo_id, :integer, unique: true
  end
end

class AddShopIdToPlans < ActiveRecord::Migration
  def change
    add_column :plans, :shop_id, :integer, unique: true
  end
end

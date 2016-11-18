class AddPlanIdToShops < ActiveRecord::Migration
  def change
    add_column :shops, :plan_id, :integer, unique: true
  end
end

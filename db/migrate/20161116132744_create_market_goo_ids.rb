class CreateMarketGooIds < ActiveRecord::Migration
  def change
    create_table :market_goo_ids do |t|
      t.integer :shop_id
  end
      t.string :shop_domain
      t.integer :app_id

      t.timestamps null: false
    end
  end
end

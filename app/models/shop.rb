class Shop < ActiveRecord::Base
  include ShopifyApp::Shop
  include ShopifyApp::SessionStorage
  after_create :init_webhooks
  has_one :market_goo_id
  has_one :plan

  def self.find_by_shop_domain(shop_domain)
    self.where(shopify_domain: shop_domain).first
  end
end

class Uninstalled < ActiveJob::Base
	include ShopifyApp::WebhookVerification
	
  def app_uninstalled (shop_domain:, webhook:)

  	shop = Shop.find_by(shopify_domain: shop_domain)
  	shop.with_shopify_session do
  		puts 'DONE!!! PARRRRTY'
  	end
  end
end
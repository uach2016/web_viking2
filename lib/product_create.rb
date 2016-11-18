class Create < ActiveJob::Base
	include ShopifyApp::WebhookVerification
	
  def product_create (shop_domain:, webhook:)
  	binding.pry
  	shop = Shop.find_by(shopify_domain: shop_domain)
  	shop.with_shopify_session do
  		puts 'DONE!!! PARRRRTY'
  	end
  end
end
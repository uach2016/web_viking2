ShopifyApp.configure do |config|
  config.api_key = "f387f16a644311db8e21332a6dd7a759"
  config.secret = "e8dcdaac25090392bde55f7d46ca515d"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
  config.webhooks = [
   			
  {topic: 'app/uninstalled', address: 'https://stripe.unaicamino.ultrahook.com',   format: 'json'},
   { topic: 'products/create', address: 'https://stripe.unaicamino.ultrahook.com', format: 'json' },
    
  ]
end


  
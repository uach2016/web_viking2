class HomeController < ShopifyApp::AuthenticatedController
  require 'rest-client'
  require 'json'
   

  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @shop = Shop.find_by_shopify_domain(ShopifyAPI::Shop.current.domain)
    if @shop.market_goo_id.nil?
      create
    end
  end

  def create 
    @shop = ShopifyAPI::Shop.current   

    @market_goo_id = MarketGooId.new();
    @market_goo_id.shop_id = @shop.id;
    @market_goo_id.shop_domain = @shop.domain;
    
    product = 'evolution'

    params = {product: product, domain: @shop.domain, name: @shop.shop_owner, email: @shop.email, promo: @shop.domain}

    #we need to post to this address, that will give us a response which is the MARKETGOO ID
    response = RestClient.post 'https://webviking.stage.mktgoo.net/api/accounts', params, :'X-Auth-Token' => "1bb6343e8153b342f346b9559938cdb0d927a8ed"
   
    # You will need to create this field in the database on your Shop model, this will then store the MarketGoo Id which we will need shortly.
    @market_goo_id.app_id = response.body

    #Save the shiz
    @market_goo_id.save
  end

  def login_link
     puts 'clicked that button'
   @shop = ShopifyAPI::Shop.current
   @market_goo_id = MarketGooId.find_by_shop_domain(@shop.domain)

   RestClient::Request.execute(method: :get, url: "https://webviking.stage.mktgoo.net/api/login/#{@market_goo_id.app_id}", :headers => {"X-Auth-Token"=> "1bb6343e8153b342f346b9559938cdb0d927a8ed"}) do |response, request, result, &block|
   	
     if [301, 302, 307].include? response.code
       redirected_url = response.headers[:location]
       redirect_to redirected_url
     else
       response.return!(request, result, &block)
     end
   end
 end
end
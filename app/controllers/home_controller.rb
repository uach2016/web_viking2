class HomeController < ShopifyApp::AuthenticatedController
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

    plan
 
  end

  def plan

    @plan = Plan.new 
    @plan.name = "Free"  
    @plan.price = 0
    @plan.description = "1 website, Limited Dashboard Access, Summarized report, One time report, Highlights only"
    shop_id = ShopifyAPI::Shop.current.id
    @plan.shop_id = shop_id
    @plan.save
  end

  def upgrade_plan
    @plan.destroy
    @new_plan = Plan.new 
    @new_plan.name = "Premiun"  
    @new_plan.price = 19.95
    @new_plan.description = "1 website, Full report, Monthly reports, Auto submit to Social Media, Daily scan of competitor websites, Customisable reports, Marketing Stats and Metrics, Website Results Tool, Personalised Marketing Plan, Step by step guide to improve your website, Steps explained in detail, Checklist of to do and completed issues, Cancel at any time"
    shop_id = ShopifyAPI::Shop.current.id
    @new_plan.shop_id = shop_id
    @new_plan.save

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

    redirect_to :back
  end

  def login_link
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
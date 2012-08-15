module BigCommerce
  class Api

    def initialize(configuration={})
      @connection = Connection.new(configuration)
    end

    # Added getter to ensure configuration is correct
    def connection
      @connection
    end

    def store_url=(store_url)
      @connection.store_url = store_url
    end

    def username=(username)
      @connection.username = username
    end

    def api_key=(api_key)
      @connection.api_key = api_key
    end

    def verify_peer=(verify)
      @connection.verify_peer = verify
    end

    def ca_file=(path)
      @connection.ca_file = path
    end

    def get_time
      @connection.get '/time'
    end

    def get_products(params={})
      min_date_modified = params.delete(:min_date_modified)
      @connection.get('/products', params, min_date_modified.rfc2822)
    end

    def get_product(id)
      @connection.get '/products/' + id.to_s
    end
    
    def get_products_count(params={})
      min_date_modified = params.delete(:min_date_modified)
      get_count @connection.get('/products/count', params, min_date_modified.rfc2822)
    end

    def get_categories
      @connection.get '/categories'
    end
    
    def get_category(id)
      @connection.get '/categories/' + id.to_s
    end
    
    def get_product_options(product_id)
      @connection.get '/products/' + product_id.to_s + '/options'
    end
    
    def get_product_skus(product_id)
      @connection.get '/products/' + product_id.to_s + '/skus'
    end
    
    def get_orders(params={})
      @connection.get('/orders', params)
    end

    def get_orders_by_date(date, params={})
      if date.is_a?(String)
        date = DateTime.parse(date)
      end
      date = date.rfc2822
      @connection.get('/orders', params.merge!(:min_date_created => CGI::escape(date)))
    end

    def get_orders_count(params={})
      get_count @connection.get('/orders/count', params)
    end

    def get_order(id)
      @connection.get '/orders/' + id.to_s
    end

    def get_order_products(id)
      @connection.get '/orders/' + id.to_s + '/products'
    end

    def get_customers
      @connection.get '/customers'
    end

    def get_customer(id)
      @connection.get '/customers/' + id.to_s
    end

    private

    def get_count(result)
      result["count"]
    end

    def get_resource(result)

    end

    def get_collection(result)

    end

  end
end
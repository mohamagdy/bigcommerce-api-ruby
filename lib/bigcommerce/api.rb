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
    
    # Products
    def get_products(params={})
      min_date_modified = params.delete(:min_date_modified)
      @connection.get('/products', params, min_date_modified.try(:rfc2822))
    end

    def get_product(id)
      @connection.get '/products/' + id.to_s
    end
    
    def create_product(params)
      @connection.post('/products', params) 
    end
    
    def get_products_count(params={})
      min_date_modified = params.delete(:min_date_modified)
      get_count @connection.get('/products/count', params, min_date_modified.try(:rfc2822))
    end

    def delete_product(product_id)
      @connection.delete('/products/' + product_id.to_s)
    end
    
    def update_product(product_id, params)
      @connection.put('/products/' + product_id.to_s, params)
    end
    
    def get_product_skus(product_id)
      @connection.get '/products/' + product_id.to_s + '/skus'
    end
    
    # Options
    def get_product_options(product_id)
      @connection.get '/products/' + product_id.to_s + '/options'
    end
    
    def get_product_options_values(option_id)
      @connection.get '/options/' + option_id.to_s + '/values'
    end
    
    def get_options
      @connection.get '/options'
    end
    
    def get_option(option_id)
      @connection.get '/options/' + option_id.to_s
    end
    
    # Categories
    def get_categories
      @connection.get '/categories'
    end
    
    def get_category(id)
      @connection.get '/categories/' + id.to_s
    end
    
    # Shipment
    def get_shipments(order_id)
      @connection.get('/orders/' + order_id.to_s + '/shipments')
    end
    
    def get_shipment(order_id, shipment_id)
      @connection.get('/orders/' + order_id.to_s + '/shipments/' + shipment_id.to_s)
    end
    
    def create_shipment(order_id, params)
      @connection.post('/orders/' + order_id.to_s + '/shipments', params)
    end
    
    def update_shipment(order_id, shipment_id, params)
      @connection.put('/orders/' + order_id.to_s + '/shipments/' + shipment_id.to_s, params)
    end
    
    def get_shipping_addresses(order_id)
      @connection.get('/orders/' + order_id.to_s + '/shippingaddresses')
    end
    
    # Orders
    def get_orders(params={})
      min_date_modified = params.delete(:min_date_modified)
      @connection.get('/orders', params, min_date_modified.try(:rfc2822))
    end

    def get_orders_by_date(date, params={})
      if date.is_a?(String)
        date = DateTime.parse(date)
      end
      date = date.rfc2822
      @connection.get('/orders', params.merge!(:min_date_created => CGI::escape(date)))
    end

    def get_orders_count(params={})
      min_date_modified = params.delete(:min_date_modified)
      get_count @connection.get('/orders/count', params, min_date_modified.try(:rfc2822))
    end

    def get_order(id)
      @connection.get '/orders/' + id.to_s
    end
    
    def update_order(id, params)
      @connection.put('/orders/' + id.to_s, params)
    end
    
    def get_order_products(id)
      @connection.get '/orders/' + id.to_s + '/products'
    end
    
    def get_order_statuses
      @connection.get '/orderstatuses'
    end
    
    def get_line_items(order_id)
      @connection.get '/orders/' + order_id.to_s + '/products'  
    end
    
    # Customers
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
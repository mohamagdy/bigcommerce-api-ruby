module BigCommerce
  class Connection

    def initialize(configuration)
      @configuration = configuration
    end

    def store_url=(store_url)
      @configuration[:store_url] = store_url
    end

    def username=(username)
      @configuration[:username] = username
    end

    def api_key=(api_key)
      @configuration[:api_key] = api_key
    end

    def verify_peer=(verify)
      @configuration[:verify_peer] = verify
    end

    def ca_file=(path)
      @configuration.ca_file = path
    end

    def get(path, params = nil, modified_since = nil)
      request(:get, path, nil, params, modified_since)
    end

    def post(path, params = nil)
      request(:post, path, nil, params)
    end

    def put(path, params = nil)
      request(:put, path, nil, params)
    end

    def delete(path)
      request(:delete, path)
    end

    def request(method, path, body = nil, params = {}, modified_since = nil)

      url = @configuration[:store_url] + '/api/v2' + path

      param_string = hash_to_params(params) if !params.nil? && !params.empty? && ![:post, :put].include?(method)

      unless (param_string.nil? || param_string.empty?)
        uri = URI.parse("#{url}?#{param_string}")
      else
        uri = URI.parse(url)
      end


      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      if @configuration.has_key?(:verify_peer) && @configuration[:verify_peer]
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      else
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end

      http.ca_file = @configuration[:ca_path] if @configuration.has_key?(:ca_path)

      request = case method
                  when :get then
                    Net::HTTP::Get.new(uri.request_uri)
                  when :post then
                    Net::HTTP::Post.new(uri.request_uri)
                  when :put then
                    Net::HTTP::Put.new(uri.request_uri)
                  when :delete then
                    Net::HTTP::Delete.new(uri.request_uri)
                end
      
      request.basic_auth(@configuration[:username], @configuration[:api_key])
      request.add_field 'Accept', 'application/json'
      request.add_field 'Content-Type', 'application/json'
      request['If-Modified-Since'] = modified_since if modified_since
      response = [:post, :put].include?(method) ? http.request(request, params) : http.request(request) 
      
      p response, response.body, '----------------------'
      return case response
               when Net::HTTPSuccess, Net::HTTPRedirection
                 JSON.parse(response.body || "{}")
               else
                 false
             end
    end

    def hash_to_params(hash)
      return nil if hash.nil? || hash.empty?

      # convert the hash to URL params
      return hash.map {|pair| pair.join("=")}.join("&")


    end
  end


  class HttpError < Exception

  end
end
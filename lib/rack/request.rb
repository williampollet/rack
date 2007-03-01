require 'rack/utils'

module Rack
  # Rack::Request provides a convenient interface to a Rack
  # environment.  It is stateless, the environment +env+ passed to the
  # constructor will be directly modified.
  #
  #   req = Rack::Request.new(env)
  #   req.post?
  #   req.params["data"]
  
  class Request
    # The environment of the request.
    attr_reader :env
    
    def initialize(env)
      @env = env
    end

    def body;            @env["rack.input"]                       end
    def scheme;          @env["rack.url_scheme"]                  end
    def script_name;     @env["SCRIPT_NAME"].to_s                 end
    def path_info;       @env["PATH_INFO"].to_s                   end
    def port;            @env["SERVER_PORT"].to_i                 end
    def request_method;  @env["REQUEST_METHOD"]                   end
    def query_string;    @env["QUERY_STRING"].to_s                end

    def host
      # Remove port number.
      (@env["HTTP_HOST"] || @env["SERVER_NAME"]).gsub(/:\d+\z/, '')
    end

    def script_name=(s); @env["SCRIPT_NAME"] = s.to_s             end
    def path_info=(s);   @env["PATH_INFO"] = s.to_s               end

    def get?;            request_method == "GET"                  end
    def post?;           request_method == "POST"                 end
    def put?;            request_method == "PUT"                  end
    def delete?;         request_method == "DELETE"               end

    # Returns the data recieved in the query string.
    def GET
      if @env["rack.request.query_string"] == query_string
        @env["rack.request.query_hash"]
      else
        @env["rack.request.query_string"] = query_string
        @env["rack.request.query_hash"]   =
          Utils.parse_query(query_string)
      end
    end

    # Returns the data recieved in the request body.
    #
    # This method support both application/x-www-form-urlencoded and
    # multipart/form-data.
    def POST
      if @env["rack.request.form_input"] == @env["rack.input"]
        @env["rack.request.form_hash"]
      else
        @env["rack.request.form_input"] = @env["rack.input"]
        unless @env["rack.request.form_hash"] =
            Utils::Multipart.parse_multipart(env) 
          @env["rack.request.form_vars"] = @env["rack.input"].read
          @env["rack.request.form_hash"] = Utils.parse_query(@env["rack.request.form_vars"])
        end
        @env["rack.request.form_hash"]
      end
    end

    # The union of GET and POST data.
    def params
      self.GET.update(self.POST)
    end

    def cookies
      return {}  unless @env["HTTP_COOKIE"]

      if @env["rack.request.cookie_string"] == @env["HTTP_COOKIE"]
        @env["rack.request.cookie_hash"]
      else
        @env["rack.request.cookie_string"] = @env["HTTP_COOKIE"]
        # XXX sure?
        @env["rack.request.cookie_hash"] =
          Utils.parse_query(@env["rack.request.cookie_string"], ';,')
      end
    end

    def xhr?
      @env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    end

    # Tries to return a remake of the original request URL as a string.
    def url
      url = scheme + "://"
      url << host

      if scheme == "https" && port != 443 ||
          scheme == "http" && port != 80
        url << ":#{port}"
      end

      url << script_name
      url << path_info

      unless query_string.empty?
        url << "?" << query_string
      end

      url
    end
  end
end

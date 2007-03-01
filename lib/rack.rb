# Copyright (C) 2007 Christian Neukirchen <purl.org/net/chneukirchen>
#
# Rack is freely distributable under the terms of an MIT-style license.
# See COPYING or http://www.opensource.org/licenses/mit-license.php.

$: << File.expand_path(File.dirname(__FILE__))


# The Rack main module, serving as a namespace for all core Rack
# modules and classes.
#
# All modules meant for use in your application are <tt>autoload</tt>ed here,
# so it should be enough just to <tt>require rack.rb</tt> in your code.

module Rack
  # The Rack version number.
  VERSION = [0,1]

  # Return the Rack version as a dotted string.
  def self.version
    VERSION.join(".")
  end

  autoload :Builder, "rack/builder"
  autoload :CommonLogger, "rack/commonlogger"
  autoload :File, "rack/file"
  autoload :ForwardRequest, "rack/recursive"
  autoload :Lint, "rack/lint"
  autoload :Recursive, "rack/recursive"
  autoload :Reloader, "rack/reloader"
  autoload :ShowExceptions, "rack/showexceptions"
  autoload :URLMap, "rack/urlmap"
  autoload :Utils, "rack/utils"

  autoload :MockRequest, "rack/mock"
  autoload :MockResponse, "rack/mock"

  autoload :Request, "rack/request"
  autoload :Response, "rack/response"

  # *Adapters* connect Rack with third party web frameworks.
  #
  # Rack includes adapters for Camping and Rails.
  #
  # Refer to the submodules for framework-specific calling details.

  module Adapter
    autoload :Camping, "rack/adapter/camping"
    autoload :Rails, "rack/adapter/rails"
  end

  # *Handlers* connect web servers with Rack.
  #
  # Rack includes Handlers for Mongrel, WEBrick, FastCGI and CGI.
  #
  # Handlers usually are activated by calling <tt>MyHandler.run(myapp)</tt>.
  # A second optional hash can be passed to include server-specific
  # configuration.

  module Handler
    autoload :CGI, "rack/handler/cgi"
    autoload :FastCGI, "rack/handler/fastcgi"
    autoload :Mongrel, "rack/handler/mongrel"
    autoload :WEBrick, "rack/handler/webrick"
  end
end


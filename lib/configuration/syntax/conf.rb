module Configuration
  module Syntax
    module Conf
      def self.method_missing(method, *args)
        Configuration.method_missing(method, args)
      end
    end
  end
end

include Configuration::Syntax

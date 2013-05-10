module Configuration
  module Syntax
    # Provides a shorthand for access config files
    #
    # For example:
    #
    #   # The following code
    #   Conf.foo
    #
    #   # is the same as:
    #   Configuration.foo
    #
    module Conf
      def self.method_missing(method, *args)
        Configuration.method_missing(method, args)
      end
    end
  end
end

include Configuration::Syntax

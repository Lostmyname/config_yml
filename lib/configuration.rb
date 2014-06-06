require "yaml"

require "configuration/syntax"
require "configuration/railtie" if defined?(Rails)
require "configuration/version"

module Configuration
  # Returns a hash with configuration for the given class method
  # called. The configuration is loaded from the file config/+method_called+.yml.
  # If the hash contains a key in the first level with the same name of environment,
  # the value of this key is returned. Returns nil if file is not found.
  #
  # For example:
  #   ## config/database.yml
  #   # development:
  #   #   host: "localhost"
  #   #   username: "root"
  #
  #   ENV["RACK_ENV"] # => "development"
  #   Configuration.database # => { :host => "localhost", :username => "root" }
  #
  class << self
    attr_accessor :root

    def method_missing(method, *args)
      if file = files.select { |f| f == files_path(method.to_s) }[0]
        hash[method] ||= load_yml(file)
      end
    end

    def files
      @files ||= Dir.glob(files_path)
    end

    def env
      @env ||= (ENV["RACK_ENV"] || Rails.env).to_sym rescue nil
    end

    private

    def files_path(filename="*")
      root.nil? ? "config/#{filename}.yml" : File.join(root, "config/#{filename}.yml")
    end

    def hash
      @hash ||= {}
    end

    def load_yml(file)
      config = with_symbol_keys YAML.load_file(file)
      config.is_a?(Hash) && config.has_key?(env) ?
        config[env] : config
    end

    def with_symbol_keys(hash_config)
      return hash_config unless hash_config.is_a?(Hash)

      hash_config.inject({}) do |symbolized, (key, value)|
        symbolized.merge({ key.to_sym => with_symbol_keys(value), key => value })
      end
    end
  end
end

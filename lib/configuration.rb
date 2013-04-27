require "yaml"

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
  #   Configuration.database # => { :host => "localhost", :username => "tmp/mysql.sock" }
  #
  class << self
    def method_missing(method, *args)
      if file = files.select { |f| f =~ /#{method.to_s}/ }[0]
        hash[method.to_s] ||= load_yml(file)
      end
    end

    def files
      @files ||= Dir.glob("config/*.yml")
    end

    def hash
      @hash ||= {}
    end

    private

    def load_yml(file)
      config = YAML.load_file(file)
      config.is_a?(Hash) && config.has_key?(ENV["RACK_ENV"].to_sym) ?
        config[ENV["RACK_ENV"].to_sym] : config
    end
  end
end

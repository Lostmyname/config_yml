config.yml
==========

Simplify your app configuration.

Description
-----------

config.yml provides a very simple way of configure your ruby applications through yaml files.

Examples
--------

```yaml
# config/redis.yml
password: foo
host: localhost
port: 6379
database: bar
```

```ruby
if redis = Configuration.redis
  password = redis[:password] && ":#{redis[:password]}@"
  ENV["REDIS_URL"] = %(redis://#{password}#{redis[:host]}:#{redis[:port]}/#{redis[:database]})
end

ENV["REDIS_URL"] # => "redis://:foo@localhost:6379/bar"
```


#### Environment based:

```yaml
# config/mysql.yml
development:
  adapter: mysql2
  encoding: utf8
  database: myapp_development
  username: foo
  password:
  socket: /tmp/mysql.sock

test:
  adapter: mysql2
  encoding: utf8
  database: myapp_test
  username: foo
  password:
  socket: /tmp/mysql.sock
```

Rack
```ruby
ENV["RACK_ENV"] # => "development"
Configuration.mysql[:database] # => "myapp_development"
```

Rails
```ruby
Rails.env # => "test"
Configuration.mysql[:database] # => "myapp_test"
```


#### Nested:

```yaml
# config/russian_doll.yml
foo:
  bar:
    baz:
      array:
        - :red
        - :green
        - :blue
```

```ruby
Configuration.russian_doll[:foo][:bar][:baz] # => { :array => [:red, :green, :blue] }
```

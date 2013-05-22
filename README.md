config_yml
==========

[![Build Status](https://travis-ci.org/vitork/config_yml.png?branch=master)](https://travis-ci.org/vitork/config_yml)
[![Code Climate](https://codeclimate.com/github/vitork/config_yml.png)](https://codeclimate.com/github/vitork/config_yml)


Simplify your app configuration.

Description
-----------

config_yml provides a very simple way of configure your ruby applications through yaml files.

Installation
------------

If you are using Bundler, add the following code to your Gemfile:

```ruby
gem "config_yml", :require => "configuration"
```

and run:

```console
$ bundle install
```

If you are not using Bundler:

```console
$ gem install config_yml
```

then in your Ruby code:

```ruby
require "configuration"
```

Usage
-----

Create any yml file inside config/ and it will became a hash.

```yaml
# config/redis.yml
password: foo
host: localhost
port: 6379
database: 1
```

```ruby
if redis = Configuration.redis
  password = redis[:password] && ":#{redis[:password]}@"
  ENV["REDIS_URL"] = %(redis://#{password}#{redis[:host]}:#{redis[:port]}/#{redis[:database]})
end

ENV["REDIS_URL"] # => "redis://:foo@localhost:6379/1"
```

You can also use the shorthand:

```ruby
redis = Conf.redis # => { :password => "foo", :host => "localhost", :port => 6379, :database => 1 }
```

To see all available yml files and configurations:

```ruby
Configuration.files # => ["config/redis.yml"]
Configuration.hash # => { :redis => { :password => "foo", :host => "localhost", :port => 6379, :database => 1 } }
```

Obs.: File names must match Ruby method name restrictions. E.g. don't use config/my-app.yml, use config/my_app.yml instead.

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
# config/matryoshka.yml
foo:
  bar:
    baz:
      array:
        - :red
        - :green
        - :blue
```

```ruby
Configuration.matryoshka[:foo][:bar][:baz] # => { :array => [:red, :green, :blue] }
```

Manage yaml files
-----------------

Avoid maintain .yml files in your repository since they very ofter cointain sensitive information. You can use .yml.sample or .yml.example file instead with fake data.

To transform sample files in yaml files, you can use the following task:

```console
$ rake config_yml:generate
```

If you are not using Rails, first add this to your Rakefile:

```ruby
require "configuration/tasks"
```

License
-------

Copyright 2013 Vitor Kiyoshi Arimitsu - http://vitork.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

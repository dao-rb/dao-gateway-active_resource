# Dao::Gateway::ActiveResource

[![Gem Version](https://badge.fury.io/rb/dao-gateway-active_resource.svg)](https://badge.fury.io/rb/dao-gateway-active_resource)
[![Build Status](https://travis-ci.org/dao-rb/dao-gateway-active_resource.svg?branch=master)](https://travis-ci.org/dao-rb/dao-gateway-active_resource)
[![Code Climate](https://codeclimate.com/github/dao-rb/dao-gateway-active_resource/badges/gpa.svg)](https://codeclimate.com/github/dao-rb/dao-gateway-active_resource)
[![Test Coverage](https://codeclimate.com/github/dao-rb/dao-gateway-active_resource/badges/coverage.svg)](https://codeclimate.com/github/dao-rb/dao-gateway-active_resource/coverage)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dao-gateway-active_resource'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dao-gateway-active_resource

## Usage

```ruby
require 'dao/entity'
require 'dao/repository'
require 'dao/gateway/active_resource'

class Post < ActiveResource::Base
end

class PostEntity < Dao::Entity::Base
  attribute :id,       Integer
  attribute :body,     String
end

class PostRepository < Dao::Repository::Base
  entity PostEntity
  gateway Dao::Gateway::ActiveResource::Base, Post, Dao::Gateway::ActiveResource::BaseTransformer
end

post = PostRepository.last

post.id # => 1
post.body # => "Post body"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dao-rb/dao-gateway-active_resource.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

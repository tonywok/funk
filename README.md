# Funk

Funk is an structured computation implementation inspired by Prismatic's [Graph](https://github.com/Prismatic/plumbing#graph-the-functional-swiss-army-knife) library.

## Installation

_Note:_ This has not yet been released on rubygems, but will be shortly.

Add this line to your application's Gemfile:

```ruby
gem 'funk-rb'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install funk-rb

## Usage

```ruby
graph = Funk::Graph.new({
  a: -> (b, d) { "#{b}, #{d}" },
  b: -> (c, e) { "#{c}, #{e}" },
  c: -> (d, e, h) { "#{d}, #{e}, #{h}" }
})

compiled_graph = graph.compile
compiled_graph.call({
  d: "d",
  e: "e",
  h: "h",
})

# evaluates to:
#
# {
#   :d=>"d",
#   :e=>"e",
#   :h=>"h",
#   :c=>"d, e, h",
#   :b=>"d, e, h, e",
#   :a=>"d, e, h, e, d”,
# }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tonywok/funk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

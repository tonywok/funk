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
# compile a graph of functions which can be inter-dependent.
stats = Funk.compile(
  count: -> (items) { items.length },
  mean:  -> (items, count) { (items.reduce(:+) / count).round(1) },
  mean_sq: -> (items, count) { (items.reduce(1) { |m, i| m + i**2 } / count).round(1) },
  variance: -> (mean, mean_sq) { (mean_sq - mean**2).round(1) }
)

# funk-rb figures out what order to call them in so dependencies are satisfied
stats.call(items: (1..10).to_a.map(&:to_f))
#=> {:items=>[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0],
     :count=>10,
     :mean=>5.5,
     :mean_sq=>38.6,
     :variance=>8.4}

# Can call the same function more than once with different input.
stats.call(items: [1,1,2,3,5,8,13].map(&:to_f))
#=> {:items=>[1.0, 1.0, 2.0, 3.0, 5.0, 8.0, 13.0],
     :count=>7,
     :mean=>4.7,
     :mean_sq=>39.1,
     :variance=>17.0}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tonywok/funk. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

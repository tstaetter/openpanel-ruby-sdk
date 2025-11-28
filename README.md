# Openpanel::SDK

OpenPanel SDK for Ruby

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add openpanel-sdk
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install openpanel-sdk
```

## Usage example

Use the gem by adding the following line to the Gemfile:

```ruby
tracker = OpenPanel::SDK::Tracker.new
identify_user = OpenPanel::SDK::IdentifyUser.new

# ... set user props

tracker.identify identify_user
tracker.track 'test_event', payload: { name: 'test' }
tracker.increment_property identify_user, 'test_property', 1
tracker.decrement_property identify_user, 'test_property', 1
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/openpanel-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

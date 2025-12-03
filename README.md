# Openpanel::SDK

[OpenPanel](https://openpanel.dev/) SDK for Ruby

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

### Simple example

```ruby
tracker = OpenPanel::SDK::Tracker.new
identify_user = OpenPanel::SDK::IdentifyUser.new

# ... set user props

tracker.identify identify_user
tracker.track 'test_event', payload: { name: 'test' }
tracker.increment_property identify_user, 'test_property', 1
tracker.decrement_property identify_user, 'test_property', 1
```

See [spec](spec) for more.

### Rails example

Now imagine you have a Rails app, you can add the following to your `application_controller.rb`:

```ruby
before_action :set_openpanel_tracker

protected

def set_openpanel_tracker
  @openpanel_tracker = OpenPanel::SDK::Tracker.new({ env: Rails.env.to_s }, disabled: Rails.env.development?)
  @openpanel_tracker.set_header "x-client-ip", request.ip
  @openpanel_tracker.set_header "user-agent", request.user_agent
end
```

then you can use `@openpanel_tracker` in your controllers:

```ruby
@openpanel_tracker.track 'test_event', payload: { name: 'test' }
```

Don't forget to set your env vars in `.env` file:

```
OPENPANEL_TRACK_URL=https://api.openpanel.dev/track
OPENPANEL_CLIENT_ID=<YOUR_CLIENT_ID>
OPENPANEL_CLIENT_SECRET=<YOUR_CLIENT_SECRET>
```

as shown in [.env_sample](.env_sample)

### Filtering events

Filters are used to prevent sending events to OpenPanel in certain cases.π
You can filter events by passing a `filter` lambda expression to the `track` method:

```ruby
filter = lambda { |payload|
  true if payload[:name] == 'test'
}
response = tracker.track('test_event', payload: { name: 'test' }, filter: filter)
# response is nil
``````

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tstaetter/openpanel-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

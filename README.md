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

then you can use `@openpanel_tracker` in your controllers to track events:

```ruby
@openpanel_tracker.track 'test_event', payload: { name: 'test' }
```

or to identify users:

```ruby
def identify_user_from_app_user(user, properties: {})
  iu = OpenPanel::SDK::IdentifyUser.new
  iu.profile_id = user.id.to_s
  iu.email = user.email
  iu.first_name = user.first_name
  iu.last_name = user.last_name
  iu.properties = properties

  iu
end

iu = identify_user_from_app_user current_user
response = @openpanel_tracker.identify iu
# Faraday::Response
``````

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

### Revenue tracking

Revenue tracking is done easily:

```ruby
response = tracker.revenue user, 100, { currency: 'EUR' }
# Faraday::Response
```

If you need to add the device ID, you can fetch it from the SDK:

```ruby
device_id = tracker.device_id
# <Some-fancy-id>
``````

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tstaetter/openpanel-sdk.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

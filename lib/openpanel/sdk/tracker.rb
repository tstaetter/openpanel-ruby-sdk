# frozen_string_literal: true

require 'faraday'

module OpenPanel
  module SDK
    class OpenPanelError < StandardError; end

    # OpenPanel SDK tracker class. Use this class to track events in OpenPanel by using
    # the OpenPanel backend API.
    class Tracker
      TRACKING_TYPE_IDENTIFY = 'identify'
      TRACKING_TYPE_TRACK = 'track'
      TRACKING_TYPE_INCREMENT = 'increment'
      TRACKING_TYPE_DECREMENT = 'decrement'

      attr_reader :headers, :global_properties

      # Initialize OpenPanel tracker
      # @param global_props [Hash] global properties to send with every `track` and `identify` event
      # @param disabled [Boolean] disable sending tracking events, defaults to false
      def initialize(global_props, disabled: false)
        @headers = {
          'Content-Type' => 'application/json',
          'openpanel-client-id' => ENV['OPENPANEL_CLIENT_ID'],
          'openpanel-client-secret' => ENV['OPENPANEL_CLIENT_SECRET']
        }
        @disabled = disabled
        @global_properties = global_props
      end

      # Set custom header for OpenPanel request
      # @param key [String] header key
      # @param value [String] header value
      def set_header(key, value)
        @headers[key] = value
      end

      # Track events in OpenPanel
      # https://openpanel.dev/docs/api/track
      # @param event [String] name of event
      # @param tracking_type [String]
      # @param payload [Hash] event payload
      # @param filter [Lambda] pass in a lambda to filter events. If the lambda returns true, the event won't be tracked.
      # @return [Faraday::Response | nil] The Faraday plain response object or nil, if the event was filtered out
      # @raise [OpenPanel::SDK::OpenPanelError] if the request fails or the event filter is not a method or lambda
      def track(event, tracking_type: TRACKING_TYPE_TRACK, payload: {}, filter: ->(_payload) { false })
        return if filter.call(payload)

        payload = global_properties.merge(payload) unless global_properties.empty?
        payload = { type: tracking_type, payload: { name: event, properties: payload } }

        send_request payload: payload
      rescue StandardError => e
        raise OpenPanel::SDK::OpenPanelError, e.message
      end

      # Identify user in OpenPanel
      # https://openpanel.dev/docs/api/track
      # @param user [OpenPanel::SDK::IdentifyUser] user to identify
      def identify(user)
        properties = user.properties.merge(global_properties) unless global_properties.empty?
        payload = { profileId: user.profile_id, firstName: user.first_name, lastName: user.last_name,
                    email: user.email, properties: properties }
        payload = { type: TRACKING_TYPE_IDENTIFY, payload: payload }

        send_request payload: payload
      end

      # Decrement property in OpenPanel
      # @param user [OpenPanel::SDK::IdentifyUser] user to identify
      # @param property [String] property to increment
      # @param value [Integer] value to increment by
      def increment_property(user, property = 'visits', value = 1)
        payload = { profileId: user.profile_id, property: property, value: value }
        payload = { type: TRACKING_TYPE_INCREMENT, payload: payload }

        send_request payload: payload
      end

      # Decrement property in OpenPanel
      # @param user [OpenPanel::SDK::IdentifyUser] user to identify
      # @param property [String] property to increment
      # @param value [Integer] value to decrement by
      def decrement_property(user, property = 'visits', value = 1)
        payload = { profileId: user.profile_id, property: property, value: value }
        payload = { type: TRACKING_TYPE_DECREMENT, payload: payload }

        send_request payload: payload
      end

      # Track revenue in OpenPanel
      # @param user [OpenPanel::SDK::IdentifyUser] user to identify
      # @param amount [Integer] amount of revenue
      # @param properties [Hash] additional properties to track
      def revenue(user, amount, properties = {})
        payload = { name: "revenue", properties: { profileId: user.profile_id, revenue: amount }.merge(properties) }
        payload = { type: TRACKING_TYPE_TRACK, payload: payload }

        send_request payload: payload
      end

      private

      # Send request to OpenPanel API
      # @param url [String] API endpoint URL
      # @param payload [Hash] request payload
      # @return [Faraday::Response] The Faraday plain response object
      # @raise [OpenPanel::SDK::OpenPanelError] if request fails
      def send_request(url: ENV['OPENPANEL_TRACK_URL'], payload: {})
        return if @disabled

        response = Faraday.post url, payload.to_json, @headers

        case response.status
        when 401
          raise OpenPanel::SDK::OpenPanelError, 'Unauthorized'
        when 429
          raise OpenPanel::SDK::OpenPanelError, 'Too many requests'
        when 500
          raise OpenPanel::SDK::OpenPanelError, 'Internal server error'
        else
          response
        end
      rescue StandardError => e
        raise OpenPanel::SDK::OpenPanelError, e.message
      end
    end
  end
end

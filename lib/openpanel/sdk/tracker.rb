# frozen_string_literal: true

require 'faraday'

module OpenPanel
  module SDK
    class OpenPanelError < StandardError; end

    class Tracker
      TRACKING_TYPE_IDENTIFY = 'identify'
      TRACKING_TYPE_TRACK = 'track'
      TRACKING_TYPE_INCREMENT = 'increment'
      TRACKING_TYPE_DECREMENT = 'decrement'

      attr_reader :headers

      ##############################
      # Initialize OpenPanel tracker
      # @param disabled [Boolean] disable sending tracking events, defaults to false
      ##############################
      def initialize(disabled: false)
        @headers = {
          'Content-Type' => 'application/json',
          'openpanel-client-id' => ENV['OPENPANEL_CLIENT_ID'],
          'openpanel-client-secret' => ENV['OPENPANEL_CLIENT_SECRET']
        }
        @disabled = disabled
      end

      ##############################
      # Set custom header for OpenPanel request
      # @param key [String] header key
      # @param value [String] header value
      ##############################
      def set_header(key, value)
        @headers[key] = value
      end

      ##############################
      # Track events in OpenPanel
      # https://openpanel.dev/docs/api/track
      # @param event [String] name of event
      # @param tracking_type [String]
      # @param payload [Hash] event payload
      ##############################
      def track(event, tracking_type: TRACKING_TYPE_TRACK, payload: {})
        payload = { type: tracking_type, payload: { name: event, properties: payload } }

        send_request payload: payload
      end

      ##############################
      # Track page view in OpenPanel
      # @param user [User] user to track
      # @param path [String] page path
      ##############################
      def track_page_view(user, path)
        if user
          track 'view', payload: { profileId: user.profile_id, path: path }
        else
          track 'view', payload: { path: path }
        end
      end

      ##############################
      # Identify user in OpenPanel
      # https://openpanel.dev/docs/api/track
      # @param user [OpenPanel::SDK::IdentifyUser] user to identify
      ##############################
      def identify(user)
        payload = { profileId: user.profile_id, firstName: user.first_name, lastName: user.last_name,
                    email: user.email }
        payload = { type: TRACKING_TYPE_IDENTIFY, payload: payload }

        send_request payload: payload
      end

      ##############################
      # Decrement property in OpenPanel
      # @param user [User] user to identify
      # @param property [String] property to increment
      # @param value [Integer] value to increment by
      #############################
      def increment_property(user, property = 'visits', value = 1)
        payload = { profileId: user.profile_id, property: property, value: value }
        payload = { type: TRACKING_TYPE_INCREMENT, payload: payload }

        send_request payload: payload
      end

      ##############################
      # Decrement property in OpenPanel
      # @param user [User] user to identify
      # @param property [String] property to increment
      # @param value [Integer] value to decrement by
      #############################
      def decrement_property(user, property = 'visits', value = 1)
        payload = { profileId: user.profile_id, property: property, value: value }
        payload = { type: TRACKING_TYPE_DECREMENT, payload: payload }

        send_request payload: payload
      end

      private

      ##############################
      # Send request to OpenPanel API
      # @param url [String] API endpoint URL
      # @param payload [Hash] request payload
      # @return [Faraday::Response] The Faraday plain response object
      # @raise [OpenPanel::SDK::OpenPanelError] if request fails
      ##############################
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

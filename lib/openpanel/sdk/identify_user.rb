# frozen_string_literal: true

module OpenPanel
  module SDK
    # Identify user payload class. Use this class to identify a user in OpenPanel.
    # @attr profile_id [String] user profile ID
    # @attr email [String] user email address
    # @attr first_name [String] user first name
    # @attr last_name [String] user last name
    # @attr properties [Hash] user properties
    class IdentifyUser
      attr_accessor :profile_id, :email, :first_name, :last_name, :properties

      def to_json(*_args)
        {
          profileId: profile_id,
          email: email,
          firstName: first_name,
          lastName: last_name,
          properties: properties
        }.to_json
      end
    end
  end
end

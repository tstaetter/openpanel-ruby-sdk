# frozen_string_literal: true

module OpenPanel
  module SDK
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

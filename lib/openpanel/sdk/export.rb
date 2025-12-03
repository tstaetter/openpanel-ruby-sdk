# frozen_string_literal: true

module OpenPanel
  module SDK
    class OpenPanelExportError < StandardError; end

    # OpenPanel SDK date range helper values.
    module DateRange
      LAST_30_MINS = '30m'
      LAST_HOUR = 'lastHour'
      TODAY = 'today'
      YESTERDAY = 'yesterday'
      LAST_7_DAYS = '7d'
      LAST_30_DAYS = '30d'
      LAST_6_MONTHS = '6m'
      LAST_12_MONTHS = '12m'
      MONTH_TO_DATE = 'monthToDate'
      LAST_MONTH = 'lastMonth'
      YEAR_TO_DATE = 'yearToDate'
      LAST_YEAR = 'lastYear'
    end

    # OpenPanel SDK export class. Use this class to export data from OpenPanel.
    class Export
      ENDPOINT_EVENTS = 'events'
      ENDPOINT_CHARTS = 'charts'

      attr_reader :project_id

      # Initialize OpenPanel export
      # @param project_id [String] OpenPanel project ID
      def initialize(project_id)
        @project_id = project_id
      end

      def events(start_date:, end_date:, filter: nil)
        url = "#{ENV['OPENPANEL_EXPORT_URL']}/#{ENDPOINT_EVENTS}?projectId=#{@project_id}"

        send_request url: url
      end

      private

      # Send request to OpenPanel API
      # @param url [String] API endpoint URL
      # @return [Faraday::Response] The Faraday plain response object
      # @raise [OpenPanel::SDK::OpenPanelExportError] if request fails
      def send_request(url:)
        response = Faraday.get(url)

        case response.status
        when 400
          raise OpenPanel::SDK::OpenPanelExportError, 'Bad request'
        when 401
          raise OpenPanel::SDK::OpenPanelExportError, 'Unauthorized'
        when 403
          raise OpenPanel::SDK::OpenPanelExportError, 'Forbidden'
        when 404
          raise OpenPanel::SDK::OpenPanelExportError, 'Not found'
        when 429
          raise OpenPanel::SDK::OpenPanelExportError, 'Too many requests'
        when 500
          raise OpenPanel::SDK::OpenPanelExportError, 'Internal server error'
        else
          response
        end
      rescue StandardError => e
        raise OpenPanel::SDK::OpenPanelExportError, e.message
      end
    end
  end
end

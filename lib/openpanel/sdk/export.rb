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


      def initialize(project_id)
      end

      private

      def send_request(payload)
        raise OpenPanelExportError, 'Not implemented yet'
      end
    end
  end
end

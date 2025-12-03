# frozen_string_literal: true

module OpenPanel
  module SDK
    # OpenPanel SDK query class. Use this class as a helper to create queries to OpenPanel by using the
    # OpenPanel backend API.
    class Query
      attr_accessor :profile_id, :event, :start, :end,
                    :page, :limit, :includes

      def to_query
        "&#{@profile_id}&event=#{@event}&start=#{@start}&end=#{@end}&page=#{@page}&limit=#{@limit}&includes=#{@includes}"
      end
    end
  end
end

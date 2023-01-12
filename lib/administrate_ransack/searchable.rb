# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def scoped_resource
      @ransack_results = super.ransack(params[:q])
      @ransack_results.result(distinct: true)
    end

    # ref => https://github.com/thoughtbot/administrate/blob/v0.18.0/app/helpers/administrate/application_helper.rb#L72-L78
    def sanitized_order_params(page, current_field_name)
      collection_names = page.item_associations + [current_field_name]
      association_params = collection_names.map do |assoc_name|
        { assoc_name => %i[order direction page per_page] }
      end
      params.permit(:search, :id, :page, :per_page, association_params, q: {})
    end

    class << self
      def prepended(base)
        base.helper_method :sanitized_order_params
      end
    end
  end
end

# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def scoped_resource
      options = respond_to?(:ransack_options, true) ? ransack_options : {}
      distinct = respond_to?(:ransack_result_distinct, true) ? ransack_result_distinct : true
      @ransack_results = prepare_search(resource_collection: super, query_params: params[:q], options: options)
      @ransack_results.result(distinct: distinct)
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

    private

    def prepare_search(resource_collection:, query_params:, options:)
      resource_collection.ransack(query_params, **options)
    rescue ArgumentError => e
      if defined?(Ransack::InvalidSearchError) && e.is_a?(Ransack::InvalidSearchError) # rubocop:disable Style/GuardClause
        ransack_invalid_search_error(e)
        resource_collection.ransack({}, **options)
      else
        raise e
      end
    end

    def ransack_invalid_search_error(error)
      if respond_to?(:invalid_search_callback, true)
        invalid_search_callback(error)
      else
        flash.now[:alert] = I18n.t('administrate_ransack.errors.invalid_search', default: error.message)
      end
    end
  end
end

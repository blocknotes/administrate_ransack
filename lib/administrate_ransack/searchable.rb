# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def prepare_search(dashboard)
      binding.pry

      search = {}
      # search[:attribute_labels] ||= {}
      # search[:attribute_types] ||= dashboard.attribute_types.select do |key, _value|
      #   dashboard.collection_attributes.include?(key)
      # end
      # search[:form_options] = { html: { 'data-administrate-ransack-filters': '1' } }
      # # if local_assigns.has_key?(:search_path)
      # #   form_path = @ransack_results
      # #   form_options[:url] = search_path
      # #   clear_filters_path = search_path
      # # else
      # #   form_path = [:admin, @ransack_results]
      # #   clear_filters_path = url_for(url_for([:admin, @ransack_results.klass]))
      # # end
      search
    end

    def scoped_resource
      @ransack_results = super.ransack(params[:q])
      @ransack_results.result(distinct: true)
    end

    # ref => https://github.com/thoughtbot/administrate/blob/v0.15.0/app/helpers/administrate/application_helper.rb#L54-L60
    def sanitized_order_params(page, current_field_name)
      collection_names = page.item_includes + [current_field_name]
      association_params = collection_names.map do |assoc_name|
        { assoc_name => %i[order direction page per_page] }
      end
      params.permit(:search, :id, :page, :per_page, association_params, q: {})
    end

    class << self
      def prepended(base)
        base.helper_method :prepare_search, :sanitized_order_params
      end
    end
  end
end

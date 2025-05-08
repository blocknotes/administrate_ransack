# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def filter_resources(resources, search_term:)
      query = params[:q] || parse_search_term(search_term, model: resources.klass)
      @ransack_results = prepare_search(resource_collection: resources, query_params: query)
      setup_view_attrs(dashboard: dashboard, model: resources.klass)
      prepare_result(@ransack_results)
    end

    # ref => https://github.com/thoughtbot/administrate/blob/v0.18.0/app/helpers/administrate/application_helper.rb#L72-L78
    def sanitized_order_params(page, current_field_name)
      collection_names = page.item_associations + [current_field_name]
      association_params = collection_names.map do |assoc_name|
        { assoc_name => %i[order direction page per_page] }
      end
      params.permit(:search, :id, :page, :per_page, :utf8, :_page, association_params, q: {})
    end

    class << self
      def prepended(base)
        base.helper_method :sanitized_order_params
      end
    end

    private

    def parse_search_term(search_term, model:)
      return {} if search_term.blank?

      terms_regex = /(\w+):"([^"]+)"|(\w+):'([^']+)'|(\w+):(\w+)/
      terms = search_term.scan(terms_regex).map(&:compact)
      terms.to_h.transform_keys do |key|
        model.ransackable_attributes.include?(key) ? "#{key}_cont" : key
      end
    end

    def prepare_search(resource_collection:, query_params:)
      options = respond_to?(:ransack_options, true) ? ransack_options : {}
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

    def setup_view_attrs(dashboard:, model:)
      @model = model
      @fields = prepare_fields_for(dashboard: dashboard)
    end

    def prepare_fields_for(dashboard:)
      dashboard_class = dashboard.class
      fields = defined?(dashboard_class::RANSACK_SEARCH) ? dashboard_class::RANSACK_SEARCH : {}
      fields.to_h do |field, conf|
        [field, eval_type(dashboard: dashboard, field: field, conf: conf)]
      end
    end

    def eval_type(dashboard:, field:, conf:)
      param = "#{field}_eq"
      options = {}
      label = field.to_s
      type =
        if conf.blank?
          field_type = dashboard.attribute_type_for(field).to_s
          AdministrateRansack::FILTERS[field_type]
        elsif conf.is_a?(Hash)
          type = (conf[:type] || :string).to_sym
          param = "#{field}_cont" if type == :string
          param = field.to_s if conf[:scope]
          param = conf[:param] if conf[:param].present?
          options = conf[:options] if conf[:options].present?
          label = conf[:label] if conf[:label].present?
          type
        else
          conf
        end

      [type, param, options, label]
    end

    def prepare_result(ransack_results)
      distinct = respond_to?(:ransack_result_distinct, true) ? ransack_result_distinct : true
      ransack_results.result(distinct: distinct)
    end
  end
end

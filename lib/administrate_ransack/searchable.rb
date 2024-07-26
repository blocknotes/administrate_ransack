# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def scoped_resource
      options = respond_to?(:ransack_options) ? ransack_options : {}
      begin
        @ransack_results = super.ransack(params[:q], **options)
      rescue ArgumentError => e
        handle_ransack_argument_error(e)
        set_flash_message_as_ransack_argument_error(e)
        @ransack_results = reset_ransack_result_on_error(super).ransack({}, **options)
      end
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

    private

    def set_flash_message_as_ransack_argument_error(error)
      if error.message.eql?("Invalid sorting parameter provided")
        flash.now[:alert] = I18n.t(
          :invalid_sorting_parameter_provided,
          scope: [:administrate_ransack, :errors],
          default: error.message
        )
      elsif error.message.start_with?("Invalid search term ")
        flash.now[:alert] = I18n.t(
          :invalid_search_term,
          search_term: error.message.split(' ')[3..].join(' '),
          scope: [:administrate_ransack, :errors],
          default: error.message
        )
      end
    end

    def handle_ransack_argument_error(error)
      super if defined?(super)
    end

    def reset_ransack_result_on_error(super_scoped_resource)
      super_scoped_resource.none
    end
  end
end

# frozen_string_literal: true

require 'ransack'

module AdministrateRansack
  module Searchable
    def scoped_resource
      @ransack_results = super.ransack(params[:q])
      @ransack_results.result(distinct: true)
    end
  end
end

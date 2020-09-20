# frozen_string_literal: true

require 'ransack'

module Searchable
  # extend ActiveSupport::Concern

  # included do
  # end

  def scoped_resource
    @q = super.ransack(params[:q])
    @q.result(distinct: true)
  end
end

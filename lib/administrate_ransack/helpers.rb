# frozen_string_literal: true

module AdministrateRansack
  class << self
    def ransack?(model, params = {}, options = {})
      ransack = model.ransack(params, **options)
      ransack.instance_variable_get(:@scope_args).present? || ransack.base.c.present?
    end
  end
end

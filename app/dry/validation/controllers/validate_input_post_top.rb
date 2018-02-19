# frozen_string_literal: true

require 'dry-validation'

class ValidateInputPostTop
  def call(params)
    schema = Dry::Validation.Schema do
      configure { config.input_processor = :sanitizer }

      required(:top_number) { type?(Integer) & gteq?(1) }
    end

    schema.call(top_number: params[:top_number])
  end
end

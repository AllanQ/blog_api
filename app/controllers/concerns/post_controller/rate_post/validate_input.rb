# frozen_string_literal: true

require 'dry-validation'

class PostController::RatePost::ValidateInput
  def call(params)
    schema = Dry::Validation.Schema do
      configure { config.input_processor = :sanitizer }

      required(:post_id) { type?(Integer) & gteq?(1) }
      required(:rate) { type?(Integer) & gteq?(1) & lteq?(5) }
    end

    schema.call(post_id: params[:post_id],
                rate:    params[:rate])
  end
end

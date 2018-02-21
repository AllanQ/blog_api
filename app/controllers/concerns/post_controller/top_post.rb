# frozen_string_literal: true

require 'dry/transaction'

class PostController::TopPost
  include Dry::Transaction

  step :validate_params
  step :define_top_post

  def validate_params(input)
    validation_result = ValidateInput.new.call(input[:params])
    if validation_result.success?
      Right(params: validation_result.output)
    else
      Left(status: 422, response: validation_result.errors)
    end
  end

  def define_top_post(input)
    posts = Post.order('rating DESC NULLS LAST')
                .limit(input[:params][:top_number])
                .pluck(:title, :content)
                .map { |values| Hash[%i[title content].zip(values)] }
    if posts.present?
      Right(status: 200, response: posts)
    else
      Left(status: 404,
           response: { post: ['no post exists'] })
    end
  end
end

# frozen_string_literal: true

require "#{Rails.root}/app/dry/validation/controllers/validate_input_post_rate"
require 'dry/transaction'

class RatePost
  include Dry::Transaction

  step :validate_params
  step :define_and_rate_post

  def validate_params(input)
    validation_result = ValidateInputPostRate.new.call(input[:params])
    if validation_result.success?
      Right(params: validation_result.output)
    else
      Left(status: 422, response: validation_result.errors)
    end
  end

  def define_and_rate_post(input)
    Post.transaction(isolation: :read_committed) do
      post = Post.find_by(id: input[:params][:post_id])
      if post
        new_rates_sum = post.rates_sum + input[:params][:rate]
        new_rates_count = post.rates_count + 1
        new_rating = new_rates_sum * 1_000 / new_rates_count
        post.update!(rating: new_rating,
                     rates_sum: new_rates_sum,
                     rates_count: new_rates_count)
        raiting = new_rating.yield_self do |r|
          str = r.to_s.sub(/0*$/, '')
          str.length > 1 ? "#{str[0]},#{str[1..-1]}" : str
        end
        Right(status: 200, response: { rating: raiting })
      else
        Left(status: 404,
             response: { post_id: ['post with this id does not exist'] })
      end
    end
  end
end

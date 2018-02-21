# frozen_string_literal: true

require 'dry/transaction'

class PostController::CreatePost
  include Dry::Transaction

  step :validate_params
  step :define_user
  step :define_ip
  step :define_connection
  step :create_post

  def validate_params(input)
    validation_result = ValidateInput.new.call(input[:params])
    if validation_result.success?
      Right(params: validation_result.output)
    else
      Left(status: 422, response: validation_result.errors)
    end
  end

  def define_user(input)
    is_user_new = false
    user = User.find_by(login: input[:params][:login])
    unless user
      user = User.create!(login: input[:params][:login])
      is_user_new = true
    end
    Right(input.merge(user_id: user.id, is_user_new: is_user_new))
  end

  def define_ip(input)
    is_ip_new = false
    ip = Ip.find_by(address: input[:params][:ip_address])
    if ip
      ip.increment!(:users_count).save! if input[:is_user_new]
    else
      Ip.create!(address: input[:params][:ip_address])
      is_ip_new = true
    end
    Right(input.merge(is_ip_new: is_ip_new))
  end

  def define_connection(input)
    if input[:is_user_new] || input[:is_ip_new]
      Connection.create!(ip_address: input[:params][:ip_address],
                         user_id:    input[:user_id])
    end
    Right(input)
  end

  def create_post(input)
    post = Post.create!(user_id:    input[:user_id],
                        ip_address: input[:params][:ip_address],
                        title:      input[:params][:title],
                        content:    input[:params][:content])
    Right(status: 200, response: post.attributes)
  end
end

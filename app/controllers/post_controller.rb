# frozen_string_literal: true

require "#{Rails.root}/app/dry/transaction/post_controller/create_post"

class PostController < ApplicationController
  def create
    result = CreatePost.new.call(params: params).value
    render status: result[:status], json: Oj.dump(result[:response])
  end
end

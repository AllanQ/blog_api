# frozen_string_literal: true

class PostController < ApplicationController
  def create
    result = CreatePost.new.call(params: params).value
    render status: result[:status], json: Oj.dump(result[:response])
  end

  def rate
    result = RatePost.new.call(params: params).value
    render status: result[:status], json: Oj.dump(result[:response])
  end

  def top
    result = TopPost.new.call(params: params).value
    render status: result[:status], json: Oj.dump(result[:response])
  end

  def popular_ip
    result = PopularIpPost.new.call.value
    render status: result[:status], json: Oj.dump(result[:response])
  end
end

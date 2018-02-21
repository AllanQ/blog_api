# frozen_string_literal: true

class PostController::PopularIpPost::Result
  attr_reader :value

  def initialize(value)
    @value = value
  end
end

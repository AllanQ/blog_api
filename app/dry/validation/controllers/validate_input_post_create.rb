# frozen_string_literal: true

require 'dry-validation'
require 'resolv'

class ValidateInputPostCreate
  def call(params)
    schema = Dry::Validation.Schema do
      configure { config.input_processor = :sanitizer }

      required(:login) { type?(String) & size?(2..80) }
      required(:ip_address) do
        type?(String) &
          (format?(Resolv::IPv4::Regex) | format?(Resolv::IPv6::Regex))
      end
      required(:title) { type?(String) & filled? }
      required(:content) { type?(String) & filled? }
    end

    schema.call(login:      params[:login],
                ip_address: params[:ip],
                title:      params[:title],
                content:    params[:content])
  end
end

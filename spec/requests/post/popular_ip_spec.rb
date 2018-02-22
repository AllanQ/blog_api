# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post', type: :request do
  describe 'popular_ip' do
    let(:url) { '/popular_ip' }

    let(:headers) do
      {
        'ACCEPT' => 'application/vnd.api+json'
      }
    end

    before do
      Connection.delete_all
      User.delete_all
      10.times do
        login = [*('A'..'Z'), *('a'..'z'), *('0'..'9')].sample(20).join
        user_id = User.create!(login: login).id
        ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
        Connection.create!(ip_address: ip_address, user_id: user_id)
      end
    end

    context 'there are some popular ip' do
      before do
        user_id = User.create!(login: 'Alex').id
        another_user_id = User.create!(login: 'Bob').id
        one_anoth_user_id = User.create!(login: 'Mike').id
        %w[127.0.0.1 127.0.0.2 127.0.0.3].each do |ip_address|
          Connection.create!(ip_address: ip_address, user_id: user_id)
          Connection.create!(ip_address: ip_address, user_id: another_user_id)
          Connection.create!(ip_address: ip_address, user_id: one_anoth_user_id)
        end
      end

      it 'returns 3 popular ip' do
        get url, headers: headers
        expect(response.status).to eql(200)

        resp_body = [{ ip_address: '127.0.0.1', logins: %w[Alex Bob Mike] },
                     { ip_address: '127.0.0.2', logins: %w[Alex Bob Mike] },
                     { ip_address: '127.0.0.3', logins: %w[Alex Bob Mike] }]
        expect(Oj.load(response.body)).to eql(resp_body)
      end
    end

    context "there isn't any popular ip" do
      it 'returns error when there are no any posts' do
        get url, headers: headers
        expect(response.status).to eql(404)

        error = { popular_ip: ['no poplular ip exists'] }
        expect(Oj.load(response.body)).to eql(error)
      end
    end
  end
end

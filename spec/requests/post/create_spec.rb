# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post', type: :request do
  describe 'create' do
    let(:url) { '/create' }

    let(:headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT_TYPE' => 'application/vnd.api+json'
      }
    end

    let(:ip_address) do
      IPAddr.new(rand(2**32), Socket::AF_INET).to_s
    end

    let(:params) do
      {
        'title'   => 'Test post',
        'content' => 'Post post post',
        'login'   => [*('A'..'Z'), *('a'..'z'), *('0'..'9')].sample(20).join,
        'ip'      => ip_address
      }
    end

    let(:params_without_title) do
      params.merge('title' => '')
    end

    let(:params_without_content) do
      params.merge('content' => nil)
    end

    let(:params_without_title_and_content) do
      params.merge('title' => nil, 'content' => '')
    end

    let(:params_without_login) do
      params.merge('login' => '')
    end

    let(:params_without_ip) do
      params.merge('ip' => nil)
    end

    it 'successfuly creates post' do
      post url, params: Oj.dump(params), headers: headers
      expect(response.status).to eql(200)

      post = Post.find_by ip_address: ip_address
      resp_body = { 'id'          => post.id,
                    'user_id'     => post.user_id,
                    'ip_address'  => ip_address,
                    'title'       => 'Test post',
                    'content'     => 'Post post post',
                    'rating'      => nil,
                    'rates_count' => 0,
                    'rates_sum'   => 0 }
      body_without_dates = Oj.load(response.body)
      body_without_dates.delete('created_at')
      body_without_dates.delete('updated_at')
      expect(body_without_dates).to eql(resp_body)
    end

    it 'successfuly creates user' do
      user_amount = User.all.count

      post url, params: Oj.dump(params), headers: headers
      expect(response.status).to eql(200)

      expect(User.all.count).to eql(user_amount + 1)
    end

    it 'successfuly creates ip' do
      ip_amount = Ip.all.count

      post url, params: Oj.dump(params), headers: headers
      expect(response.status).to eql(200)

      ip = Ip.find_by address: ip_address
      expect(ip.users_count).to eql(1)
      expect(Ip.all.count).to eql(ip_amount + 1)
    end

    it 'successfuly creates connection' do
      connection_amount = Connection.all.count

      post url, params: Oj.dump(params), headers: headers
      expect(response.status).to eql(200)

      connection = Connection.find_by ip_address: ip_address
      expect(connection).to be_truthy
      expect(Connection.all.count).to eql(connection_amount + 1)
    end

    it 'returns error when params without title' do
      post url, params: Oj.dump(params_without_title), headers: headers
      expect(response.status).to eql(422)

      error = { title: ['must be filled'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it "doesn't create user when params without title" do
      user_amount = User.all.count
      post url, params: Oj.dump(params_without_title), headers: headers

      expect(User.all.count).to eql(user_amount)
    end

    it 'returns error when params without content' do
      post url, params: Oj.dump(params_without_content), headers: headers
      expect(response.status).to eql(422)

      error = { content: ['must be String'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it "doesn't create ip when params without content" do
      ip_amount = Ip.all.count
      post url, params: Oj.dump(params_without_content), headers: headers

      expect(Ip.all.count).to eql(ip_amount)
    end

    it 'returns error when params without title and content' do
      post(url,
           params: Oj.dump(params_without_title_and_content),
           headers: headers)
      expect(response.status).to eql(422)

      error = { title: ['must be String'], content: ['must be filled'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it "doesn't create connection when params without title and content" do
      post(url,
           params: Oj.dump(params_without_title_and_content),
           headers: headers)
      expect(Connection.all.count).to eql(0)
    end

    it 'returns error when params without login' do
      post url, params: Oj.dump(params_without_login), headers: headers
      expect(response.status).to eql(422)

      error = { login: ['length must be within 2 - 80'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params without ip' do
      post url, params: Oj.dump(params_without_ip), headers: headers
      expect(response.status).to eql(422)

      error = { ip_address: ['must be String'] }
      expect(Oj.load(response.body)).to eql(error)
    end
  end
end

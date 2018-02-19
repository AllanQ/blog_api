# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post', type: :request do
  describe 'rate' do
    let(:url) { '/rate' }

    let(:headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT_TYPE' => 'application/vnd.api+json'
      }
    end

    let(:one_post) do
      login = [*('A'..'Z'), *('a'..'z'), *('0'..'9')].sample(20).join
      user_id = User.create!(login: login).id
      ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
      Ip.create!(address: ip_address)
      Connection.create!(ip_address: ip_address, user_id: user_id)
      Post.create!(user_id: user_id,
                   ip_address: ip_address,
                   title: 'Title',
                   content: 'Content',
                   rating: 4_000,
                   rates_count: 2,
                   rates_sum: 8)
    end

    let(:another_post) do
      login = [*('A'..'Z'), *('a'..'z'), *('0'..'9')].sample(20).join
      user_id = User.create!(login: login).id
      ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
      Ip.create!(address: ip_address)
      Connection.create!(ip_address: ip_address, user_id: user_id)
      Post.create!(user_id: user_id,
                   ip_address: ip_address,
                   title: 'Title',
                   content: 'Content',
                   rating: 5_000,
                   rates_count: 3,
                   rates_sum: 15)
    end

    it 'successfuly rates post' do
      params = Oj.dump('post_id' => one_post.id, 'rate' => 5)
      post url, params: params, headers: headers
      expect(response.status).to eql(200)

      one_post.reload
      expect(one_post.rating).to eql(4_333)
      expect(one_post.rates_sum).to eql(13)
      expect(one_post.rates_count).to eql(3)
      expect(Oj.load(response.body)).to eql(rating: '4,333')
    end

    it 'successfuly rates another post' do
      params = Oj.dump('post_id' => another_post.id, 'rate' => 1)
      post url, params: params, headers: headers
      expect(response.status).to eql(200)

      another_post.reload
      expect(another_post.rating).to eql(4_000)
      expect(another_post.rates_sum).to eql(16)
      expect(another_post.rates_count).to eql(4)
      expect(Oj.load(response.body)).to eql(rating: '4')
    end

    it 'successfuly rates one more' do
      params = Oj.dump('post_id' => another_post.id, 'rate' => 3)
      post url, params: params, headers: headers
      expect(response.status).to eql(200)

      another_post.reload
      expect(another_post.rating).to eql(4_500)
      expect(another_post.rates_sum).to eql(18)
      expect(another_post.rates_count).to eql(4)
      expect(Oj.load(response.body)).to eql(rating: '4,5')
    end

    it 'returns error when params without post_id' do
      post url, params: Oj.dump('post_id' => '', 'rate' => 1), headers: headers
      expect(response.status).to eql(422)

      error = { post_id: ['must be Integer'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params without rate' do
      post url, params: Oj.dump('post_id' => 5, 'rate' => nil), headers: headers
      expect(response.status).to eql(422)

      error = { rate: ['must be Integer'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params without post_id and rate' do
      params = Oj.dump('post_id' => nil, 'rate' => '')
      post url, params: params, headers: headers
      expect(response.status).to eql(422)

      error = { post_id: ['must be Integer'], rate: ['must be Integer'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params with wrong post_id' do
      post url, params: Oj.dump('post_id' => 0, 'rate' => 1), headers: headers
      expect(response.status).to eql(422)

      error = { post_id: ['must be greater than or equal to 1'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params with wrong rate' do
      post url, params: Oj.dump('post_id' => 4, 'rate' => 6), headers: headers
      expect(response.status).to eql(422)

      error = { rate: ['must be less than or equal to 5'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params with wrong rate' do
      post url, params: Oj.dump('post_id' => 4, 'rate' => 0), headers: headers
      expect(response.status).to eql(422)

      error = { rate: ['must be greater than or equal to 1'] }
      expect(Oj.load(response.body)).to eql(error)
    end

    it 'returns error when params with nonexistent post_id' do
      post url, params: Oj.dump('post_id' => 999, 'rate' => 1), headers: headers
      expect(response.status).to eql(404)

      error = { post_id: ['post with this id does not exist'] }
      expect(Oj.load(response.body)).to eql(error)
    end
  end
end

# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Post', type: :request do
  describe 'top' do
    let(:url) { '/top' }

    let(:headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT_TYPE' => 'application/vnd.api+json'
      }
    end

    context 'there are some posts' do
      before do
        Post.delete_all
        login = [*('A'..'Z'), *('a'..'z'), *('0'..'9')].sample(20).join
        user_id = User.create!(login: login).id
        ip_address = IPAddr.new(rand(2**32), Socket::AF_INET).to_s
        Connection.create!(ip_address: ip_address, user_id: user_id)
        Post.create!(user_id: user_id,
                     ip_address: ip_address,
                     title: 'first',
                     content: 'raiting 4000',
                     rating: 4_000,
                     rates_count: 2,
                     rates_sum: 8)
        Post.create!(user_id: user_id,
                     ip_address: ip_address,
                     title: 'second',
                     content: 'raiting nil')
        Post.create!(user_id: user_id,
                     ip_address: ip_address,
                     title: 'third',
                     content: 'raiting 5000',
                     rating: 5_000,
                     rates_count: 3,
                     rates_sum: 15)
        Post.create!(user_id: user_id,
                     ip_address: ip_address,
                     title: 'fourth',
                     content: 'raiting 2000',
                     rating: 2_000,
                     rates_count: 2,
                     rates_sum: 4)
        Post.create!(user_id: user_id,
                     ip_address: ip_address,
                     title: 'fifth',
                     content: 'raiting nil')
      end

      it 'returns 5 top posts' do
        post url, params: Oj.dump('top_number' => 5), headers: headers
        expect(response.status).to eql(200)

        resp_body = [{ title: 'third',  content: 'raiting 5000' },
                     { title: 'first',  content: 'raiting 4000' },
                     { title: 'fourth', content: 'raiting 2000' },
                     { title: 'fifth',  content: 'raiting nil' },
                     { title: 'second', content: 'raiting nil' }]
        expect(Oj.load(response.body)).to eql(resp_body)
      end

      it 'returns 5 top posts' do
        post url, params: Oj.dump('top_number' => 77), headers: headers
        expect(response.status).to eql(200)

        resp_body = [{ title: 'third',  content: 'raiting 5000' },
                     { title: 'first',  content: 'raiting 4000' },
                     { title: 'fourth', content: 'raiting 2000' },
                     { title: 'fifth',  content: 'raiting nil' },
                     { title: 'second', content: 'raiting nil' }]
        expect(Oj.load(response.body)).to eql(resp_body)
      end

      it 'returns 3 top posts' do
        post url, params: Oj.dump('top_number' => 3), headers: headers
        expect(response.status).to eql(200)

        resp_body = [{ title: 'third',  content: 'raiting 5000' },
                     { title: 'first',  content: 'raiting 4000' },
                     { title: 'fourth', content: 'raiting 2000' }]
        expect(Oj.load(response.body)).to eql(resp_body)
      end

      it 'returns 1 top post' do
        post url, params: Oj.dump('top_number' => 1), headers: headers
        expect(response.status).to eql(200)

        resp_body = [{ title: 'third', content: 'raiting 5000' }]
        expect(Oj.load(response.body)).to eql(resp_body)
      end

      it 'returns error when top_number is nil' do
        post url, params: Oj.dump('top_number' => nil), headers: headers
        expect(response.status).to eql(422)

        error = { top_number: ['must be Integer'] }
        expect(Oj.load(response.body)).to eql(error)
      end

      it 'returns error when top_number is sting' do
        post url, params: Oj.dump('top_number' => 'more'), headers: headers
        expect(response.status).to eql(422)

        error = { top_number: ['must be Integer'] }
        expect(Oj.load(response.body)).to eql(error)
      end

      it 'returns error when top_number is zero' do
        post url, params: Oj.dump('top_number' => 0), headers: headers
        expect(response.status).to eql(422)

        error = { top_number: ['must be greater than or equal to 1'] }
        expect(Oj.load(response.body)).to eql(error)
      end

      it 'returns error when top_number is negative' do
        post url, params: Oj.dump('top_number' => -1), headers: headers
        expect(response.status).to eql(422)

        error = { top_number: ['must be greater than or equal to 1'] }
        expect(Oj.load(response.body)).to eql(error)
      end
    end

    context 'there are no posts' do
      before do
        Post.delete_all
      end

      it 'returns error when there are no any posts' do
        post url, params: Oj.dump('top_number' => 5), headers: headers
        expect(response.status).to eql(404)

        error = { post: ['no post exists'] }
        expect(Oj.load(response.body)).to eql(error)
      end
    end
  end
end

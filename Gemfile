# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'active_model_serializers', '0.10.7'
gem 'dry-transaction', '0.10.2'
gem 'dry-validation', '0.11.1'
gem 'oj', '3.4'
gem 'pg', '0.21.0'
gem 'puma', '3.11.2'
gem 'rails', '5.1.4'

group :development do
  gem 'listen', '3.1.5'
  gem 'spring', '2.0.2'
  gem 'spring-watcher-listen', '2.0.1'
end

group :development, :test do
  gem 'byebug', '10.0.0', platforms: %i[mri mingw x64_mingw]
  gem 'rspec-rails', '3.7.2'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

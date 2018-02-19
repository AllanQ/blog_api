# frozen_string_literal: true

Rails.application.routes.draw do
  post 'create', to: 'post#create'
  post 'rate',   to: 'post#rate'
  post 'top',    to: 'post#top'
end

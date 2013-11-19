module Lessonable
  class Engine < ::Rails::Engine
  
    # To load the routes for this Engine, within your main apps routes.rb file include
    # the following:
    #
    #   Lessonable::Engine.routes
    def self.routes
      Rails.application.routes.draw do
        ActiveAdmin.routes(self)
        devise_for :users
        resources :businesses, only: [:show, :create, :update]
        resources :lessons, only: [:show, :create, :update]
        resources :cards, only: [:create]
        resources :subscriptions, only: [:update, :destroy]
      end
    end
  end
end
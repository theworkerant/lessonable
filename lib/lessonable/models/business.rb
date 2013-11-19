module Lessonable
  module Business
    extend ActiveSupport::Concern
    include ActiveModel::Validations
    
    included do
      validates_presence_of :name, :message => "can't be blank"
      validates_presence_of :description, :message => "can't be blank"
      
      has_one :user
    end

  end
end
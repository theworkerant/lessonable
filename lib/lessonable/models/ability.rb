module Lessonable
  module Ability
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    
    ROLES = %w( admin business instructor student )
    
    def initialize(user)
      user.role ||= "student"
      roles = ROLES[ROLES.index(user.role)..-1]
      roles.each { |role| send(role) }
    end
    
    def admin
      can :manage, :all
    end
      
    def business
      can :manage, Business, business_id: [1,2,3]
    end
    def instructor
    end
    
    def student
    end
  end
end
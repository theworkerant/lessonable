module Lessonable
  class Ability
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    
    ROLES = %w( admin business instructor student default )
    SUBSCRIBABLE_ROLES = ROLES - ["admin"]
    
    def initialize(user)
      user.role ||= "default"
      roles = ROLES[ROLES.index(user.role)..-1]
      roles.each { |role| send(role) }
    end
    
    def admin
      can :manage, :all
    end
      
    def business
      can :create, Business
    end
    def instructor
    end
    
    def student
      
    end
    def default
    end
  end
end
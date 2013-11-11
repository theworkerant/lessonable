module Lessonable
  class BusinessAbility
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    
    ROLES = %w( owner instructor office customer default )
    
    def initialize(user, business)
      @business = business
      roles = ROLES[ROLES.index(user.role_for(@business))..-1]
      roles.each { |role| send(role) }
    end
    
    def owner
      can :manage, Business, {id: @business.id}
    end
    def instructor
    end
    def office
    end
    def customer
    end
    def default
    end
  end
end
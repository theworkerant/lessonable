module Lessonable
  class Ability
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    include Lessonable::CustomAbility
    
    ROLES = %w( admin business instructor student default )
    SUBSCRIBABLE_ROLES = ROLES - ["admin"]
    
    def initialize(user)
      user.role ||= "default"
      roles = ROLES[ROLES.index(user.role)..-1]
      roles.each { |role| send(role) }
      
      ROLES.each{ |role| self.send :"#{role}_abilities" }
      
      add_custom_abilities(user)
    end
    
    # Methods to be overridden
    ROLES.each {|role| define_method("#{role}_abilities") {} }
    
    def admin
      can :manage, :all
    end
    def business
      can :manage, Business
    end
    def instructor
    end
    def student
    end
    def default
      can :read, Business
    end
      
  end
end
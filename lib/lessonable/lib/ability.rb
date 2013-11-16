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
    
    private
    def add_custom_abilities(user)
      user.permissions.each do |permission|
        if permission.subject_id.nil?
          can permission.action.to_sym, permission.subject_class.constantize
        else
          can permission.action.to_sym, permission.subject_class.constantize, :id => permission.subject_id
        end
      end
    end
  end
end
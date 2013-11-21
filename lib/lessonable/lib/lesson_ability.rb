module Lessonable
  class LessonAbility
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    include Lessonable::CustomAbility
    
    ROLES = %w( owner instructor helper attendee default )
    
    def initialize(user, lesson)
      @lesson = lesson
      roles = ROLES[ROLES.index(user.role_for(@lesson))..-1]
      roles.each { |role| send(role) }
      
      ROLES.each{ |role| self.send :"#{role}_abilities" }
      
      add_custom_abilities(user)
    end
    
    # Methods to be overridden
    ROLES.each {|role| define_method("#{role}_abilities") {} }
    
    def owner
      can :manage, Lesson
    end
    def instructor
    end
    def helper
    end
    def attendee
      can :read, @lesson
    end
    def default
      can :read, Lesson
    end
  end
end
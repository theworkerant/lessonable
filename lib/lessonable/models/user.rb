module Lessonable
  module User
    extend ActiveSupport::Concern
    
    included do
      validates_presence_of :first_name, :on => :create, :message => "can't be blank"
      validates_presence_of :last_name, :on => :create, :message => "can't be blank"
      delegate :can?, :cannot?, :to => :ability
      
      has_many :roles
    end
    
    def full_name
      "#{first_name} #{last_name}"
    end

    def ability
      @ability ||= Ability.new(self)
    end
    def is?(base_role, object)
      role ||= "student"
      if object
        ability_class = Lessonable.const_get("#{object.class.to_s}Ability")
        return ability_class::ROLES.index(base_role.to_s) <= ability_class::ROLES.index(role_for(object))
      else
        return Lessonable::Ability::ROLES.index(base_role.to_s) <= Lessonable::Ability::ROLES.index(role)
      end      
    end
    def role_for(object)
      role = self.roles.find_by(rolable_id: object.id, rolable_type: object.class.to_s).role
    end 

  end
end
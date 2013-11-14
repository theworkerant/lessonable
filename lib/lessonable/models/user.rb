module Lessonable
  module User
    extend ActiveSupport::Concern
    
    included do
      validates_presence_of :first_name, :on => :create, :message => "can't be blank"
      validates_presence_of :last_name, :on => :create, :message => "can't be blank"
      delegate :can?, :cannot?, :to => :current_ability
      
      has_many :roles
      has_many :businesses, through: :roles, :source => :rolable, :source_type => "Business"
      
      belongs_to :business
      
      before_create :set_default_role
    end
    
    def full_name
      "#{first_name} #{last_name}"
    end

    def ability=(object)
      unless object
        @current_ability = Lessonable::Ability.new(self)
      else
        @current_ability = "Lessonable::#{object.class.to_s}Ability".constantize.new(self, object)  
      end
    end
    def current_ability
      @current_ability ||= Lessonable::Ability.new(self)
    end
    def is?(base_role, object=false)
      self.role ||= "default"
      if object
        ability_class = Lessonable.const_get("#{object.class.to_s}Ability")
        return ability_class::ROLES.index(base_role) >= ability_class::ROLES.index(role_for(object))
      else
        return Lessonable::Ability::ROLES.index(base_role) >= Lessonable::Ability::ROLES.index(role)
      end      
    end
    def role_for(object)
      result = self.roles.find_by(rolable_id: object.id, rolable_type: object.class.to_s)
      result ? result.role : "default"
    end 
    
    private
    def set_default_role
      self.role = Lessonable::Ability::ROLES.last unless self.role
    end

  end
end
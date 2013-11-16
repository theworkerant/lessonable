module Lessonable
  module User
    extend ActiveSupport::Concern
    include Lessonable::Subscribable
    
    included do
      validates_presence_of :first_name, :on => :create, :message => "can't be blank"
      validates_presence_of :last_name, :on => :create, :message => "can't be blank"
      delegate :can?, :cannot?, :to => :current_ability
      
      has_many :roles
      has_many :permissions
      has_many :businesses, through: :roles, :source => :rolable, :source_type => "Business"
      
      belongs_to :business
      belongs_to :subscription
      
      before_create :set_default_role
      after_create :create_subscription
      after_create :setup_stripe
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
    def stripe_customer
      Stripe::Customer.retrieve(self.customer_id)
    end
    
    private
    def set_default_role
      self.role = Lessonable::Ability::ROLES.last unless self.role
    end
    def create_subscription
      self.subscription = self.build_subscription
      self.save
    end
    def setup_stripe
      self.update_attribute :customer_id, Stripe::Customer.create(:description => "User ##{id} -- #{full_name}").id unless self.customer_id
    end

  end
end
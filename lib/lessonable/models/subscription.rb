module Lessonable
  module Subscription
    extend ActiveSupport::Concern
    
    included do
      has_one :user
      after_update :update_user_role
    end
    
    def canceled?; self.status == "canceled"; end
    def active?; self.status.match(/active|trialing/); end
      
    module ClassMethods
      def role_by_plan(plan)
        role = Subscribable::ROLE_PLANS.select{|k,v| v.include?(plan)}.keys
        role.present? ? role.first.to_s : false
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
    
    private
    def update_user_role
      if canceled?
        user.update_attribute(:role, "default")
      else
        role = self.class.role_by_plan(self.plan_id)
        user.update_attribute(:role, role) if role and active?
      end
    end 

  end
end
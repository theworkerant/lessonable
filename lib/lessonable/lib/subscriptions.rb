module Lessonable
  module Subscriptions
    require "stripe"
    
    def subscribable?(role)
      ROLE_PLANS[role.to_sym].present?
    end
    def unsubscribe(at_period_end: true)
      customer = Stripe::Customer.retrieve(self.customer_id)
      response = customer.cancel_subscription(at_period_end: at_period_end)
      unless at_period_end
        self.subscription_id  = nil
        self.role             = "default"
        self.save
      end
    end
    def subscribe_to(plan, new_role=false)
      new_role = role_by_plan(plan) unless new_role # attempt to find role by plan
      
      if new_role and not subscribable?(new_role) # role isn't subscribable, just set it
        self.role = new_role
      else
        customer = Stripe::Customer.retrieve(self.customer_id)
        response = customer.update_subscription(:plan => plan)
        
        new_role ||= "default" unless self.role
        self.role = new_role if new_role and response.status and response.status.match /active|trialing/
      end
      self.save
    end

    module ClassMethods
      def process_subscription_created(event)
        stripe_customer = Stripe::Customer.retrieve(event.data.object.customer)
        if stripe_customer.subscription.status == "active"
          object = self.find_by_customer_id(event.data.object.customer)
          object.subscription_id = event.data.object.plan.id
          object.save
        end
      end
      def process_subscription_deleted(event)
        stripe_customer = Stripe::Customer.retrieve(event.data.object.customer)
        if stripe_customer.subscription.status == "canceled"
          object = self.find_by_customer_id(event.data.object.customer)
          object.subscription_id  = nil
          object.role             = "default"
          object.save
        end
      end
      # def process_invoice_payment_succeeded(event)
      #   object = self.find_by_customer_id(event.data.object.customer)
      #   plan = event.data.object.lines.data.find{|datum| datum.keys.include?(:plan)}.plan.id
      #   object.role = ROLE_PLANS.select{|k,v| v.include?(plan)}.keys.first.to_s
      # end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
    
    private 
    def role_by_plan(plan)
      role = ROLE_PLANS.select{|k,v| v.include?(plan)}.keys
      role.present? ? role.first.to_s : false
    end
    
  end
end
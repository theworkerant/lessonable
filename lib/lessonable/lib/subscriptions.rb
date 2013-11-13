module Lessonable
  module Subscriptions
    require "stripe"
    
    def subscribable?(role)
      ROLE_PLANS[role.to_sym].present?
    end
    def subscribe_as(role,plan="")
      if subscribable?(role)
        customer = Stripe::Customer.retrieve(self.customer_id)
        customer.update_subscription(:plan => plan)
      else
        self.role = role
        return true
      end
    end
    
    module ClassMethods
      def process_subscription_created(event)
        object = self.find_by_customer_id(event.data.object.customer)
        object.subscription_id = event.data.object.plan.id if event.data.object.status == "active"
      end
      def process_invoice_payment_succeeded(event)
        object = self.find_by_customer_id(event.data.object.customer)
        plan = event.data.object.lines.data.find{|datum| datum.keys.include?(:plan)}.plan.id
        object.role = ROLE_PLANS.select{|k,v| v.include?(plan)}.keys.first.to_s
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
    
  end
end
module Lessonable
  module Subscribable
    require "stripe"
    
    # def subscribable?(plan)
    #   ROLE_PLANS.invert[plan.to_sym].present?
    # end
    def plan_for_role?(plan,role)
      ROLE_PLANS[role.to_sym].present? and ROLE_PLANS[role.to_sym].include?(plan)
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
    def subscribe_to(plan, new_role="")
      self.update_attribute(:role, new_role) if not plan or not plan_for_role?(plan, new_role) and new_role.present?
      if plan
        customer = Stripe::Customer.retrieve(self.customer_id)
        response = customer.update_subscription(:plan => plan)
        self.update_subscription(response)
      else
        self.subscription.update_attributes({
          plan_id: "noplan",
          status: "active"
        })
      end
    end
    def update_subscription(stripe_subscription)
      self.subscription.update_attributes({
        plan_id: stripe_subscription.plan.id,
        status: stripe_subscription.status,
        current_period_start: stripe_subscription.current_period_start,
        current_period_end: stripe_subscription.current_period_start,
        canceled_at: stripe_subscription.canceled_at
      })
    end

    module ClassMethods
      def process_subscription_created(event)
        update_subscription_from_webhook(event)
      end
      def process_subscription_deleted(event)
        update_subscription_from_webhook(event)
      end
      # def process_invoice_payment_succeeded(event)
      #   object = self.find_by_customer_id(event.data.object.customer)
      #   plan = event.data.object.lines.data.find{|datum| datum.keys.include?(:plan)}.plan.id
      #   object.role = ROLE_PLANS.select{|k,v| v.include?(plan)}.keys.first.to_s
      # end
      def update_subscription_from_webhook(event)
        stripe_customer = Stripe::Customer.retrieve(event.data.object.customer)
        subscribable    = self.find_by_customer_id(stripe_customer.id)
        subscribable.update_subscription stripe_customer.subscription
      end
    end
    
    def self.included(receiver)
      receiver.extend ClassMethods
    end
    

    
  end
end
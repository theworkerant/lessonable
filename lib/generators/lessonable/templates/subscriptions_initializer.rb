module Lessonable
  module Subscriptions
    Stripe.api_key = "XXX"
    
    # Fill in roles with applicable Stripe plans. Multiple plans may apply.
    # Empty means the plan doesn't require subscription.
    ROLE_PLANS = {
      business: ["XXX"],
      instructor: ["XXX"],
      student: ["XXX"],
      default: []
    }
  end
end

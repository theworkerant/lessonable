module Lessonable
  module Subscribable
    Stripe.api_key = "SDfFzkTWcPNVTlAYto3Wfkw3qe5Ehi9r"
    
    # "Plan without role" also exists in Stripe
    ROLE_PLANS = {
      business: ["The biz plan"],
      instructor: ["instructor plan"],
      student: ["student awesomeness", "student with trial"],
      default: []
    }
  end
end
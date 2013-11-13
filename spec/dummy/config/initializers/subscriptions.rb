module Lessonable
  module Subscriptions
    Stripe.api_key = "SDfFzkTWcPNVTlAYto3Wfkw3qe5Ehi9r"
    
    ROLE_PLANS = {
      business: ["The biz plan"],
      instructor: ["instructor plan"],
      student: ["student awesomeness", "student with trial"],
      default: []
    }
  end
end

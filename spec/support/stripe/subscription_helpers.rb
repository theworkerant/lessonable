# For *raw*
# replace nils with nils
# replace (.*): with $1:

def stripe_subscription_created(customer="cus_00000000000000", plan="some plan_00000000000000")
  h = {
    created: 1326853478,
    livemode: false,
    id: "evt_00000000000000",
    type: "customer.subscription.created",
    object: "event",
    data: {
      object: {
        id: "su_00000000000000",
        plan: {
          interval: "month",
          name: "Some student plan",
          amount: 6000,
          currency: "usd",
          id: plan,
          object: "plan",
          livemode: false,
          interval_count: 1,
          trial_period_days: nil
        },
        object: "subscription",
        start: 1384305743,
        status: "active",
        customer: customer,
        cancel_at_period_end: false,
        current_period_start: 1384305743,
        current_period_end: 1386897743,
        ended_at: nil,
        trial_start: nil,
        trial_end: nil,
        canceled_at: nil,
        quantity: 1,
        application_fee_percent: nil
      }
    }
  }
  
  Stripe::Event.construct_from(h)
end

def stripe_invoice_payment_succeeded(customer="cus_00000000000000", plan="some plan")
  h = {
  created: 1326853478,
  livemode: false,
  id: "evt_00000000000000",
  type: "invoice.payment_succeeded",
  object: "event",
  data: {
    object: {
      date: 1384305743,
      id: "in_00000000000000",
      period_start: 1384305743,
      period_end: 1384305743,
      lines: {
        data: [
          {
            id: "su_2vjqC1YSJHKmDy",
            object: "line_item",
            type: "subscription",
            livemode: true,
            amount: 6000,
            currency: "usd",
            proration: false,
            period: {
              start: 1386897743,
              end: 1389576143
            },
            quantity: 1,
            plan: {
              interval: "month",
              name: "Some cool plan",
              amount: 6000,
              currency: "usd",
              id: plan,
              object: "plan",
              livemode: false,
              interval_count: 1,
              trial_period_days: nil
            },
            description: nil,
            metadata: nil
          }
        ],
        count: 1,
        object: "list",
        url: "/v1/invoices/in_2vjqSzgXbldavr/lines"
      },
      subtotal: 6000,
      total: 6000,
      customer: customer,
      object: "invoice",
      attempted: true,
      closed: true,
      paid: true,
      livemode: false,
      attempt_count: 0,
      amount_due: 6000,
      currency: "usd",
      starting_balance: 0,
      ending_balance: 0,
      next_payment_attempt: nil,
      charge: "_00000000000000",
      discount: nil,
      application_fee: nil
    }
  }
}

Stripe::Event.construct_from(h)
end
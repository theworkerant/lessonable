def stripe_customer_with_card
  response = Stripe::Customer.create(
    :description => "Customer for card@subscriptions.com",
    :card => {number: "4242424242424242", exp_month: "12", exp_year: "2020"}
  )
  response.id
end
def stripe_customer_without_card
  response = Stripe::Customer.create(
    :description => "Customer for nocard@subscriptions.com"
  )
  response.id
end

# For *raw*
# replace nils with nils
# replace (.*): with $1:
def stripe_customer_object(customer="cus_00000000000000", plan="some plan_00000000000000", subscription_status:"active")
  h = {
    object: "customer",
    created: 1384274077,
    id: customer,
    livemode: false,
    description: "Customer for test@example.com",
    email: nil,
    delinquent: false,
    metadata: {
    },
    subscription: {
      id: "su_2vbKm2UYpLdDj2",
      plan: {
        interval: "month",
        name: "PricingPlan 1372",
        amount: 1372,
        currency: "usd",
        id: plan,
        object: "plan",
        livemode: false,
        interval_count: 1,
        trial_period_days: 5
      },
      object: "subscription",
      start: 1384274081,
      status: subscription_status,
      customer: customer,
      cancel_at_period_end: true,
      current_period_start: 1384274081,
      current_period_end: 1384706081,
      ended_at: nil,
      trial_start: 1384274081,
      trial_end: 1384706081,
      canceled_at: 1384274085,
      quantity: 1,
      application_fee_percent: nil
    },
    discount: nil,
    account_balance: 0,
    cards: {
      object: "list",
      count: 0,
      url: "/v1/customers/cus_2vbKknLMmEvYam/cards",
      data: [

      ]
    },
    default_card: nil
  }
  Stripe::Event.construct_from(h)
end
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
def stripe_subscription_deleted(customer="cus_00000000000000", plan="some plan_00000000000000")
  h = {
    created: 1326853478,
    livemode: false,
    id: "evt_00000000000000",
    type: "customer.subscription.deleted",
    object: "event",
    data: {
      object: {
        id: "su_00000000000000",
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
        object: "subscription",
        start: 1384358402,
        status: "canceled",
        customer: customer,
        cancel_at_period_end: false,
        current_period_start: 1384358402,
        current_period_end: 1386950402,
        ended_at: 1384226255,
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
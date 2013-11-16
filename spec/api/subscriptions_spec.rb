require "spec_helper"

feature "sign up for a subscription" do
  let(:user) { setup_controller_with_user }
  scenario "adds a card" do
    user_creates_a_new_card
    expect(parse_json(response.body)["last4"]).to eq "4242"
  end
  
  scenario "bad card added" do
    user_creates_a_new_card("4000000000000002") # returns declined code
    error = parse_json(response.body)
    expect(error["message"]).to eq "Your card was declined."
    expect(error["type"]).to eq "card_error"
    expect(error["code"]).to eq "card_declined"
    returns_code 402
  end
  scenario "purchase a subscription" do
    user_creates_a_new_card
    patch subscription_path user.subscription, {subscription: {plan: "The biz plan"}}
    expect(user.subscription.plan_id).to eq "The biz plan"
  end
  scenario "purchase a non-existent subscription" do
    user_creates_a_new_card
    patch subscription_path user.subscription, {subscription: {plan: "Some unreal plan"}}
    expect_no_such_plan("Some unreal plan")
  end
  
end if hit_stripe?

feature "purchase unlisted subscription" do
  let(:user) { setup_controller_with_user }
  scenario "purchase a private subscription" do
    user_creates_a_new_card
    user.permissions.create({subject_class: "Subscription", action: "purchase_unlisted"})
    patch subscription_path user.subscription, {subscription: {plan: "Plan without role"}}
    expect(user.subscription.plan_id).to eq "Plan without role"
  end
  scenario "purchase a private subscription without ability" do
    user_creates_a_new_card
    patch subscription_path user.subscription, {subscription: {plan: "Plan without role"}}
    expect_no_such_plan("Plan without role")
  end
end if hit_stripe?

def user_creates_a_new_card(number=nil, exp_month=nil, exp_year=nil)
  token = Stripe::Token.create({card: card_attributes(number, exp_month, exp_year)}).id
  post cards_path user, {card: {token: token}}
end
def expect_no_such_plan(name)
  error = parse_json(response.body)
  expect(error["message"]).to eq "No such plan: #{name}"
  expect(error["type"]).to eq "invalid_request_error"
  returns_code 400
end
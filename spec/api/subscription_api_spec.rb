require "spec_helper"

feature "subscriptions" do
  let(:user) { setup_controller_with_user }
  scenario "adds a card" do
    user_creates_a_new_card
    expect(parse_json(response.body)["last4"]).to eq "4242"
  end
  
  # TODO maybe move this?
  scenario "bad card added" do
    user_creates_a_new_card("4000000000000002") # returns declined code
    error = parse_json(response.body)
    expect(error["message"]).to eq "Your card was declined."
    expect(error["type"]).to eq "card_error"
    expect(error["code"]).to eq "card_declined"
    returns_code 402
  end
  scenario "purchase new" do
    signs_up_for_biz_plan
  end
  scenario "purchase a non-existent one" do
    user_creates_a_new_card
    patch subscription_path user.subscription, {subscription: {plan: "Some unreal plan"}}
    expect_no_such_plan("Some unreal plan")
  end
  scenario "cancel immediately" do
    signs_up_for_biz_plan
    
    delete subscription_path user.subscription, {subscription: {at_period_end: false}}
    expect(user.role).to eq "default"
    expect(user.subscription.reload().plan_id).to eq nil
    expect(json_response).to eq nil
    expect(response.status).to eq 200
  end
  scenario "cancel without existing" do   
    delete subscription_path user.subscription, {subscription: {at_period_end: false}}
    error = parse_json(response.body)
    expect(error["message"]).to match /No active subscriptions for customer/
    expect(error["type"]).to eq "invalid_request_error"
    returns_code 404
  end
  scenario "update existing (upgrade/downgrade)" do
    signs_up_for_biz_plan
    patch subscription_path user.subscription, {subscription: {plan: "student awesomeness"}}
    expect(user.reload().role).to eq "student"
  end
end if hit_stripe?

feature "unlisted subscriptions" do
  let(:user) { setup_controller_with_user }
  scenario "purchase an unlisted subscription" do
    user_creates_a_new_card
    user.permissions.create({subject_class: "Subscription", action: "purchase_unlisted"})
    patch subscription_path user.subscription, {subscription: {plan: "Plan without role"}}
    expect(user.subscription.plan_id).to eq "Plan without role"
  end
  scenario "purchase an unlisted subscription without ability" do
    user_creates_a_new_card
    patch subscription_path user.subscription, {subscription: {plan: "Plan without role"}}
    expect_no_such_plan("Plan without role")
  end
end if hit_stripe?

def signs_up_for_biz_plan
  user_creates_a_new_card
  patch subscription_path user.subscription, {subscription: {plan: "The biz plan"}}
  expect(user.subscription.plan_id).to eq "The biz plan"
end
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
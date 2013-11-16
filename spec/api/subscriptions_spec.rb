require "spec_helper"

feature "sign up for a subscription" do
  let(:user) { setup_controller_with_user(CardsController) }
  scenario "adds a card" do
    creates_a_new_card
    expect(parse_json(response.body)["last4"]).to eq "4242"
  end if hit_stripe?
  
  scenario "bad card added" do
    creates_a_new_card("4000000000000002") # returns declined code
    error = parse_json(response.body)
    expect(error["message"]).to eq "Your card was declined."
    expect(error["type"]).to eq "card_error"
    expect(error["code"]).to eq "card_declined"
    returns_code 402
  end
end

# def setup_user(user=nil)
#   user ||= create :user
#   return user
# end
def creates_a_new_card(number=nil, exp_month=nil, exp_year=nil)
  token = Stripe::Token.create({card: valid_card_attributes(number, exp_month, exp_year)}).id
  post cards_path user, {card: {token: token}}
end
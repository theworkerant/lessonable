require "spec_helper"

feature "sign up for a subscription" do
  before(:each) do
    setup_user
  end
  scenario "see it's glory" do
    # business = create :business
    # get business_path(business)
    pending
    expect(response.body).to be_json_eql business.to_json
    returns_code 200
  end
  scenario "it isn't found" do
    pending
    get business_path(999)
    expect_json_is_empty(response.body)
    returns_code 404
  end
end

def setup_user(user=nil)
  user ||= create :user
  return user
end
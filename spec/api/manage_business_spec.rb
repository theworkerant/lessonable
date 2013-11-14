require "spec_helper"

feature "find a business" do
  before(:each) do
    setup_user
  end
  scenario "see it's glory" do
    business = create :business
    get business_path(business)
    expect(response.body).to be_json_eql business.to_json
    returns_code 200
  end
  scenario "it isn't found" do
    business = create :business
    get business_path(999)
    expect_json_is_empty(response.body)
    returns_code 404
  end
end

feature "business creation" do
  before(:each) do
    setup_user
  end
  scenario "unauthorized user" do
    post businesses_path({business: {name: "Some Business", description: "Some description"}})
    expect_not_authorized
  end
  scenario "authorized user creates business" do
    user = setup_user create(:user, {role: "business"})
    post businesses_path({business: {name: "Some Business", description: "Some description"}})
    expect(parse_json(response.body)["id"]).to eq 1
    # expect(user.businesses.first.name).to eq "Some Business"
    returns_code 201
  end
  scenario "missing something" do
    setup_user create(:user, {role: "business"})
    post businesses_path({business: {description: "Some description"}})
    expect(parse_json(response.body)["errors"].keys).to include("name")
    returns_code 422
  end
end

feature "update a business" do
  let(:business) { create :business }
  let(:user) { create :user, role: "business" } # business role here is for sanity check
  
  before(:each) do
    setup_user user
  end
  scenario "user without business role" do
    patch business_path(business, {business: {name: "Some Business Edited!", description: "Some description"}})
    expect_not_authorized
  end
  
  scenario "user with unauthorized business role" do
    user.roles.create({role: "customer", rolable_id: business.id, rolable_type: business.class.to_s})
    patch business_path(business, {business: {name: "Some Business Edited!", description: "Some description"}})
    expect_not_authorized
  end
  context "authorized" do
    before(:each) do
      user.roles.create({role: "owner", rolable_id: business.id, rolable_type: business.class.to_s})
    end
    scenario "successfully updated" do
      patch business_path(business, {business: {name: "Some Business Edited!", description: "Some description"}})
      expect(parse_json(response.body)["id"]).to eq 1
      returns_code 200
    end
    scenario "blank required attribtue" do
      business = create :business
      patch business_path(business, {business: {name: ""}})
      returns_code 422
    end
    
  end
end

def setup_user(user=nil)
  user ||= create :user
  allow_any_instance_of(BusinessesController).to receive(:current_user).and_return(user)
  return user
end
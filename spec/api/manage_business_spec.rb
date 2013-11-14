require "spec_helper"
feature "find a business" do
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

feature "create a business" do
  scenario "successfully created" do
    post businesses_path({business: {name: "Some Business", description: "Some description"}})
    expect(parse_json(response.body)["id"]).to eq 1
    returns_code 201
  end
  scenario "missing something" do
    post businesses_path({business: {description: "Some description"}})
    expect(parse_json(response.body)["errors"].keys).to include("name")
    returns_code 422
  end
end

feature "update a business" do
  scenario "successfully updated" do
    business = create :business
    patch business_path(business, {business: {name: "Some Business", description: "Some description"}})
    expect(parse_json(response.body)["id"]).to eq 1
    returns_code 200
  end
  scenario "blank required attribtue" do
    business = create :business
    patch business_path(business, {business: {name: ""}})
    returns_code 422
  end
end
FactoryGirl.define do
  factory :business do
    name "Test Business"
    description "Lorem ipsum dolor sit amet"
  end
end

FactoryGirl.define do
  factory :user do
    first_name "Test"
    sequence(:last_name) {|n| "User #{n}"}
    role nil
  end
end

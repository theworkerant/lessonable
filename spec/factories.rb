FactoryGirl.define do
  factory :business do
    name "Test Business"
    description "Lorem ipsum dolor sit amet"
  end
end

FactoryGirl.define do
  factory :subscription do
    plan_id "some plan"
    status "active"
    current_period_start Time.now
    current_period_end 1.month.from_now
    canceled_at nil
  end
end

FactoryGirl.define do
  factory :user do
    first_name "Test"
    sequence(:last_name) {|n| "User #{n}"}
    sequence(:email) {|n| "someuser#{n}@test.com"}
    password "password"
    password_confirmation "password"
    
    customer_id {hit_stripe? ? nil : "cus_00000000000000"}
    # role
  end
end

FactoryGirl.define do
  factory :lesson do
    name "Test Lesson"
    description "Lorem ipsum dolor sit amet"
    private false
    template false
    max_occupancy 5
    duration 60
  end
end
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
    # role
  end
end

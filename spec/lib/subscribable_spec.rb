require "spec_helper"
describe Lessonable::Subscribable do
  
  it "should have an array of subscriptions for each role" do
    Lessonable::Ability::SUBSCRIBABLE_ROLES.each do |role|
      expect(Lessonable::Subscribable::ROLE_PLANS[role.to_sym]).to be_an Array
    end
  end
    
  subject { create :user }
  before(:each) do
    stripe_customer_with_card(subject)
  end
  
  it "responds to #subscription_id and #role" do
    subject.respond_to?(:subscription_id)
    subject.respond_to?(:role)
  end

  # describe "#subscribable?(plan)" do
  #   it "responds true if there is a role for a given plan" do
  #     expect(subject.subscribable?("The biz plan")).to eq true
  #     expect(subject.subscribable?("Some unknown plan")).to eq false
  #   end
  # end
  
  describe "#update_subscription(stripe_subscription)" do
    it "updates subscription attributes from stripe object" do
      pending
    end
  end
  describe "#plan_for_role?(plan,role)" do
    it "returns whether a plan exists for a given role" do
      expect(subject.plan_for_role?("No such plan", "business")).to eq false
      expect(subject.plan_for_role?("The biz plan", "business")).to eq true
    end
  end

  describe "#subscribe_to(plan,role)" do
    it "changes role instantly when no plan specified but role is" do
      subject.subscribe_to(nil, "student")
      expect(subject.reload().role).to eq "student"
    end
  end
  
  context "no existing subscription" do

    it "changes role on successful subscription" do
      allow_any_instance_of(Stripe::Customer).to receive(:update_subscription).and_return(stripe_subscription_object(plan: "The biz plan")) unless hit_stripe?
      subject.subscribe_to("The biz plan")
      expect(subject.reload().role).to eq "business"
    end
    
    it "sets the subscription upon successful subscription event" do
      allow(Stripe::Customer).to receive(:retrieve).with(subject.customer_id).and_return(stripe_customer_object(customer: subject.customer_id,plan:"student awesomeness"))
      subject.class.process_subscription_created stripe_subscription_created(subject.customer_id)
      expect(subject.subscription.reload().plan_id).to eq "student awesomeness"
    end

    context "subscribing to plan without role match" do
      it "allows subscription, default role given if no other role" do
        subject.subscribe_to("Plan without role", "student")
        expect(subject.role).to eq "student"
      end
      it "role stays the same if already set" do
        subject.role = "admin"
        subject.subscribe_to("Plan without role")
        expect(subject.role).to eq "admin"
      end
    end
    
    it "raises error when no such plan available" do
      expect(lambda{subject.subscribe_to("some bogus plan")}).to raise_error(Stripe::InvalidRequestError, "No such plan: some bogus plan")
    end if hit_stripe?

    it "raises error when no payment method available" do
      stripe_customer_without_card(subject)
      expect(lambda{subject.subscribe_to("student awesomeness")}).to raise_error(Stripe::InvalidRequestError, "You must supply a valid card")
    end if hit_stripe?
    
  end
  
  context "existing subscription" do
    before(:each) do
      subject.role = "business"
    end
    
    it "downgrades role based on new subscription" do
      allow_any_instance_of(Stripe::Customer).to receive(:update_subscription).and_return(stripe_subscription_object(plan: "student with trial")) unless hit_stripe?
      subject.subscribe_to("student with trial")
      expect(subject.reload().role).to eq "student"
    end
    
    it "upgrades role based on new subscription" do
      subject.role = "default"
      allow_any_instance_of(Stripe::Customer).to receive(:update_subscription).and_return(stripe_subscription_object(plan: "The biz plan")) unless hit_stripe?
      subject.subscribe_to("The biz plan")
      expect(subject.reload().role).to eq "business"
    end
    
    context "while trialing" do
    end
    
    context "canceled automatically" do
      before(:each) do
        stripe_customer_with_card_and_subscription(subject)
        subject.role              = "business"
        subject.subscription      = create :subscription
        subject.subscription_id   = subject.subscription.id # ActiveRecord mocked out, manual hookup
      end
    
      it "defaults role and marks subscription 'canceled'" do
        allow(Stripe::Customer).to receive(:retrieve).with(subject.customer_id).and_return(stripe_customer_object(customer: subject.customer_id, subscription_status: "canceled"))
        subject.class.process_subscription_deleted stripe_subscription_deleted(subject.customer_id)
        expect(subject.reload().role).to eq "default"
        expect(subject.subscription.status).to eq "canceled"
      end
    end
    
    context "canceled manually" do
      before(:each) do
        allow_any_instance_of(Stripe::Customer).to receive(:update_subscription).and_return(stripe_subscription_object(plan: "The biz plan")) unless hit_stripe?
        subject.subscribe_to("The biz plan")
      end
    
      it "cancels at period end by default, so changes nothing immediately" do
        subject.unsubscribe(at_period_end: true)
        expect(subject.reload().role).to eq "business"
        expect(subject.subscription.plan_id).to eq "The biz plan"
      end
      it "defaults role and removes subscription_id" do
        subject.unsubscribe(at_period_end: false)
        expect(subject.role).to eq "default"
        expect(subject.subscription.plan_id).to eq nil
      end
    end
  end
  
  # let(:invoice_success_response) { stripe_invoice_payment_succeeded(subject.customer_id, "student awesomeness") }
  # it "changes role on successful invoice" do
  #   subject.class.process_invoice_payment_succeeded(invoice_success_response)
  #   expect(subject.role).to eq "student"
  # end

end
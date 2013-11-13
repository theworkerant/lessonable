require "spec_helper"
describe Lessonable::Subscriptions do
  
  it "should have an array of subscriptions for each role" do
    Lessonable::Ability::SUBSCRIBABLE_ROLES.each do |role|
      expect(Lessonable::Subscriptions::ROLE_PLANS[role.to_sym]).to be_an Array
    end
  end
    
  # Setup a dummy class, but usually represented by a user
  class SubscribableClass
    def self.find_by_customer_id; end 
    include Lessonable::Subscriptions 
    attr_accessor :customer_id, :subscription_id, :role
  end
  subject { SubscribableClass.new() }
  before(:each) do
    stripe_customer_with_card(subject)
    allow(subject).to receive(:save).and_return(true)
  end
  
  it "responds to #subscription_id and #role" do
    subject.respond_to?(:subscription_id)
    subject.respond_to?(:role)
  end

  describe "#subscribable?(role)" do
    it "responds true if there are subscriptions for a given role" do
      expect(subject.subscribable?("business")).to eq true
      expect(subject.subscribable?("default")).to eq false
    end
  end
  
  context "signing up for a subscription" do
    it "changes role instantly for free plan" do
      subject.subscribe_to(nil, "default")
      expect(subject.role).to eq "default"
    end
    
    it "changes role on successful subscription" do
      subject.subscribe_to("The biz plan")
      expect(subject.role).to eq "business"
    end
    
    it "sets the subscription ID upon successful subscription event" do
      allow(Stripe::Customer).to receive(:retrieve).with(subject.customer_id).and_return(stripe_customer_object(subscription:true))
      event = stripe_subscription_created(subject.customer_id, "student awesomeness")
      subject.class.process_subscription_created(event)
    end

    context "subscribing to plan without role" do
      it "allows subscription, default role given if no other role" do
        subject.subscribe_to("Plan without role")
        expect(subject.role).to eq "default"
      end
      it "role stays the same if already set" do
        subject.role = "admin"
        subject.subscribe_to("Plan without role")
        expect(subject.role).to eq "admin"
      end
    end
    
    it "raises error when no such plan available" do
      expect(lambda{subject.subscribe_to("some bogus plan")}).to raise_error(Stripe::InvalidRequestError, "No such plan: some bogus plan") if hit_stripe?
    end
  end
  
  context "signing up for a subscription without valid payment method" do
    before(:each) do
      stripe_customer_without_card(subject)
    end
    it "raises error when no payment method available" do
      expect(lambda{subject.subscribe_to("student awesomeness")}).to raise_error(Stripe::InvalidRequestError, "You must supply a valid card") if hit_stripe?
    end
  end
  
  context "downgrading/upgrading subscription" do
    before(:each) do
      subject.role = "business"
    end
    
    it "downgrades role based on new subscription" do
      subject.subscribe_to("student with trial")
      expect(subject.role).to eq "student"
    end
    
    it "upgrades role based on new subscription" do
      subject.role = "default"
      subject.subscribe_to("The biz plan")
      expect(subject.role).to eq "business"
    end
  end
  
  context "automatic cancellation" do
    before(:each) do
      stripe_customer_with_card_and_subscription(subject)
      subject.role            = "business"
      subject.subscription_id = "abc123"
    end
    
    it "defaults role and removes subscription_id" do
      allow(Stripe::Customer).to receive(:retrieve).with(subject.customer_id).and_return(stripe_customer_object(subscription:true, subscription_status: "canceled"))
      subject.class.process_subscription_deleted stripe_subscription_deleted(subject.customer_id)
      expect(subject.role).to eq "default"
      expect(subject.subscription_id).to eq nil
    end
  end
  
  context "manual cancelation" do
    before(:each) do
      subject.subscribe_to("The biz plan")
      subject.subscription_id = "abc123"
    end
    
    it "cancels at period end by default, so changes nothing immediately" do
      subject.unsubscribe(at_period_end: true)
      expect(subject.role).to eq "business"
      expect(subject.subscription_id).to eq "abc123"
    end
    it "defaults role and removes subscription_id" do
      subject.unsubscribe(at_period_end: false)
      expect(subject.role).to eq "default"
      expect(subject.subscription_id).to eq nil
    end
  end
  
  # let(:invoice_success_response) { stripe_invoice_payment_succeeded(subject.customer_id, "student awesomeness") }
  # it "changes role on successful invoice" do
  #   subject.class.process_invoice_payment_succeeded(invoice_success_response)
  #   expect(subject.role).to eq "student"
  # end

end

# def setup_customer_with_card
#   subject.customer_id = stripe_customer_with_card
#   
# end
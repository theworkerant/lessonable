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

  describe "#subscribable?(role)" do
    it "responds true if there are subscriptions for a given role" do
      expect(subject.subscribable?("business")).to eq true
      expect(subject.subscribable?("default")).to eq false
    end
  end
  
  context "no subscription" do
    it "responds to #subscription_id" do
      subject.respond_to?(:subscription_id)
    end
  end
  
  context "signing up for a subscription" do
    before(:each) do
      subject.customer_id = "cus_2viuskgyoax3Bz"
      allow(subject.class).to receive(:find_by_customer_id).with(subject.customer_id).and_return(subject)
    end

    it "changes role instantly for free plan" do
      subject.subscribe_as("default")
      expect(subject.role).to eq "default"
    end
    
    let(:plan) { "student awesomeness" }
    let(:subscription_success_response) { stripe_subscription_created(subject.customer_id, plan) }
    it "changes subscription_id on successful subscription" do
      subject.subscribe_as("student", plan)
      subject.class.process_subscription_created(subscription_success_response)
      expect(subject.subscription_id).to eq plan
    end
    
    let(:invoice_success_response) { stripe_invoice_payment_succeeded(subject.customer_id, plan) }
    it "changes role on successful receipt" do
      subject.class.process_invoice_payment_succeeded(invoice_success_response)
      expect(subject.role).to eq "student"
    end
    
    it "raises error when no subscription present for role" do
      # lambda{   subject.subscribe_as("student", "no such plan") }.should raise_error(Stripe::InvalidRequestError)
      expect(lambda{subject.subscribe_as("student", "no such plan")}).to raise_error(Stripe::InvalidRequestError)
    end
  end
end
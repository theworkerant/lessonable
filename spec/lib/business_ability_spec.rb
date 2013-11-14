require "spec_helper"
describe Lessonable::BusinessAbility do
  class FakeClass
  end
  subject { Lessonable::BusinessAbility.new(create(:user), create(:business)) }

  it "default can't do anything" do
    expect(subject.can?(:manage, create(:business))).to eq false
  end
  
  describe "Owner" do
    let(:business) { create :business }
    let(:user) { create :user }
    before(:each) do
      user.roles.create({role: "owner", rolable_id: business.id, rolable_type: business.class.to_s})
    end
    subject { Lessonable::BusinessAbility.new(user, business) }
    
    it "can do anything" do
      expect(subject.can?(:manage, business)).to eq true
    end
  end
  
  describe "#xxxx_abilities" do
    it "should respond to each class + _abilities" do
      Lessonable::BusinessAbility::ROLES.each do |role|
        expect(subject.respond_to?("#{role}_abilities")).to eq true
      end
    end

    it "can be overridden to provide additional abilities" do
      expect(subject.can?(:hokey_pokey, FakeClass)).to eq false
      class Lessonable::BusinessAbility
        def owner_abilities
          can :hokey_pokey, FakeClass
        end
      end
      subject = Lessonable::BusinessAbility.new(create(:user), create(:business))
      expect(subject.can?(:hokey_pokey, FakeClass)).to eq true
    end
  end
  
end
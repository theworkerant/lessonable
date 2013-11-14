require "spec_helper"
describe Lessonable::Ability do
  class FakeClass
  end
  subject { Lessonable::Ability.new(create(:user)) }
  
  it "default can't do anything" do
    expect(subject.can?(:do_anything, FakeClass)).to eq false
  end
  
  describe "Admin" do
    subject { Lessonable::Ability.new(create(:user, {role: "admin"})) }
    it "can do anything" do
      expect(subject.can?(:do_anything, FakeClass)).to eq true
    end
  end
  
  describe "#xxxx_abilities" do
    it "should respond to each class + _abilities" do
      Lessonable::Ability::ROLES.each do |role|
        expect(subject.respond_to?("#{role}_abilities")).to eq true
      end
    end

    it "can be overridden to provide additional abilities" do
      expect(subject.can?(:hokey_pokey, FakeClass)).to eq false
      class Lessonable::Ability
        def business_abilities
          can :hokey_pokey, FakeClass
        end
      end
      subject = Lessonable::Ability.new(create(:user))
      expect(subject.can?(:hokey_pokey, FakeClass)).to eq true
    end
  end
  
end
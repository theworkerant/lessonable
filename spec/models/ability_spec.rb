require "spec_helper"
describe Lessonable::Ability do
  subject { Ability.new(create(:user)) }

  it "default can't do anything" do
    expect(subject.can?(:do_anything, Class)).to eq false
  end
  
  describe "Admin" do
    subject { Ability.new(create(:user, {role: "admin"})) }
    it "can do anything" do
      expect(subject.can?(:do_anything, Class)).to eq true
    end
  end
  
end
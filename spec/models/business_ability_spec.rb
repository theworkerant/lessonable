require "spec_helper"
describe Lessonable::BusinessAbility do
  subject { BusinessAbility.new(create(:user)) }

  it "default can't do anything" do
    pending
    # expect(subject.can?(:do_anything, Class)).to eq false
  end
  
  describe "Owner" do
    subject { BusinessAbility.new(create(:user, {role: "owner"})) }
    it "can do anything" do
      pending
      # expect(subject.can?(:do_anything, Class)).to eq true
    end
  end
  
end
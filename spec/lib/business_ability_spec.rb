require "spec_helper"
describe Lessonable::BusinessAbility do
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
  
end
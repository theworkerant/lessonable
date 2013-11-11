require "spec_helper"
describe Lessonable::User do
  subject { create :user }
  
  it "has a first, last and full name" do
    expect(subject.respond_to?(:first_name)).to eq true
    expect(subject.respond_to?(:last_name)).to eq true
    expect(subject.respond_to?(:full_name)).to eq true
  end
  it "has a role" do
    expect(subject.respond_to?(:role)).to eq true
    expect(subject.role).to eq nil
  end
  it "responds to abilities methods #can? and #cannot?" do
    expect(subject.respond_to?(:can?)).to eq true
    expect(subject.respond_to?(:cannot?)).to eq true
  end
    
  describe "Object Roles" do
    it "has roles for objects" do
      expect(subject.roles.length).to eq 0
      subject.roles.new({role: "some_role", rolable_id: 1, rolable_type: "Class"})
      expect(subject.roles.length).to eq 1
    end
    
    describe "with a role on a object" do
      let(:business) { create :business }
      before(:each) do
        subject.roles.create({role: "owner", rolable_id: business.id, rolable_type: business.class.to_s})
      end
      
      describe "#ability=(object)" do
        it "sets the ability based on the object class" do
          expect(subject.can?(:manage, business)).to eq false
          subject.ability = business
          expect(subject.can?(:manage, business)).to eq true
        end
      end

      describe "#role_for" do
        it "returns the default role if none is found" do
          expect(subject.role_for(create(:business))).to eq "default"
        end
        it "gets a role for an object using #role_for" do
          expect(subject.role_for(business)).to eq "owner"
        end
      end
      
      describe "#is?" do
        it "checks whether user has that ability" do
          expect(subject.is?("owner", business)).to eq true
        end
      end
    end
  end

end
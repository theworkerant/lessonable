require "spec_helper"
describe Lessonable::User do
  subject { create :user }
  
  it "has a first, last" do
    expect(subject.respond_to?(:first_name)).to eq true
    expect(subject.respond_to?(:last_name)).to eq true
  end
  it "has a full name of first+last" do
    subject.first_name = "Maharg"
    subject.last_name = "Salgoud Eirwop"
    expect(subject.full_name).to eq "Maharg Salgoud Eirwop"
  end
  it "has a default role of 'default'" do
    expect(subject.respond_to?(:role)).to eq true
    expect(subject.role).to eq "default"
  end
  it "responds to abilities methods #can? and #cannot?" do
    expect(subject.respond_to?(:can?)).to eq true
    expect(subject.respond_to?(:cannot?)).to eq true
  end
  it "has a customer_id" do
    expect(subject.customer_id).to be_a String
    expect(subject.customer_id).to be_present
  end
  
  describe "#is?" do
    it "checks whether user has that role" do
      expect(subject.is?("instructor")).to eq false
      expect(subject.is?("default")).to eq true
    end
  end
  describe "#stripe_customer" do
    it "returns a Stripe::Customer object" do
      allow(Stripe::Customer).to receive(:retrieve).with(subject.customer_id).and_return(stripe_customer_object) unless hit_stripe?
      expect(subject.stripe_customer).to be_a Stripe::Customer
      expect(subject.stripe_customer.id).to eq subject.customer_id
    end
  end  
  
  describe "#business" do
    before(:each) do
      other_business = create :business
      subject.roles.create({role: "owner", rolable_id: other_business.id, rolable_type: other_business.class.to_s})
      
      business = create :business
      subject.update_attribute :business_id, business.id
    end
    
    it "returns the primary business, even if other associations exist" do
      expect(Business.count).to eq 2
      expect(subject.business.id).to eq 2
    end
  end
  
  describe "#businesses" do
    
    before(:each) do
      3.times { create :business } 
      subject.roles.create({role: "owner", rolable_id: 2, rolable_type: "Business"})
      subject.roles.create({role: "office", rolable_id: 2, rolable_type: "Business"})
    end
    it "returns all business which that user is associated" do
      expect(Business.count).to eq 3
      expect(subject.businesses.count).to eq 2
    end
  end
  
  describe "Role Inheritance" do
    subject { create(:user, {role: "instructor"}) }
    it "if a user is role :instructor, he's also a student" do
      expect(subject.is?("instructor")).to eq true
      expect(subject.is?("student")).to eq true
    end
    
    it "if a user has role :instructor, he's not a business" do
      expect(subject.is?("instructor")).to eq true
      expect(subject.is?("business")).to eq false
    end
  end
  
  describe "Object Roles" do

    it "has roles for objects" do
      expect(subject.roles.length).to eq 0
      subject.roles.new({role: "some_role", rolable_id: 1, rolable_type: "Class"})
      expect(subject.roles.length).to eq 1
    end
    
    context "with a role on a object" do
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
        it "resets the ability when no object" do
          subject.ability = business
          expect(subject.can?(:manage, business)).to eq true
          subject.ability = false
          expect(subject.can?(:manage, business)).to eq false
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
        it "checks whether user has that role for an object" do
          expect(subject.is?("owner", business)).to eq true
        end
      end
    end
  end
  describe "Custom Permissions" do
    it "can give users special permissions on any object" do
      expect(subject.can?(:go_public, Business)).to eq false
      subject.permissions.create({subject_class: "Business", action: "go_public"})
      subject.current_ability = nil
      expect(subject.can?(:go_public, Business)).to eq true
    end
    let(:business) { create :business }
    let(:other_business) { create :business }
    it "can give users special permissions on a particular object" do
      expect(subject.can?(:go_public, business)).to eq false
      subject.permissions.create({subject_class: "Business", action: "go_public", subject_id: business.id})
      subject.current_ability = nil
      expect(subject.can?(:go_public, business)).to eq true
      expect(subject.can?(:go_public, other_business)).to eq false
    end
    it "custom permissions apply to other Ability classes" do
      expect(subject.can?(:go_public, business)).to eq false
      subject.permissions.create({subject_class: "Business", action: "go_public", subject_id: business.id})
      subject.ability = business
      expect(subject.can?(:go_public, business)).to eq true
      expect(subject.can?(:go_public, other_business)).to eq false
    end
  end
  
end
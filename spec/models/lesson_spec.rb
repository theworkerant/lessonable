require "spec_helper"

describe Lessonable::Lesson do
  subject { create :lesson }
  
  it "has a name and description" do
    expect(subject.respond_to?(:name)).to eq true
    expect(subject.respond_to?(:description)).to eq true
  end
  
  it "has duration" do
    expect(subject.respond_to?(:duration)).to eq true
    expect(subject.duration).to be_an Integer
  end
  
  it "has max occupancy" do
    expect(subject.respond_to?(:max_occupancy)).to eq true
    expect(subject.max_occupancy).to be_an Integer
  end
  
  describe "#template?" do
    it { expect(subject.template?).to be false}
  end
  
  describe "#private?" do
    it { expect(subject.private?).to be false}
  end
  
  context "with attendees" do
    describe "#attendees" do
      it "has none to start" do
        expect(subject.attendees).to be_empty
      end
      it "returns users with role of attendee" do
        add_attendee_to_lesson
        expect(subject.attendees.count).to eq 1
        expect(subject.attendees.first.first_name).to eq "Test"
      end
      it "doesn't returns user with higher role" do
        Role.create(user_id: create(:user).id, role: "instructor", rolable_type: "Lesson", rolable_id: subject.id)
        expect(subject.attendees.count).to eq 0
      end
    end
    
    describe "#full?" do
      it "is true when attendees is greater than #max_occupancy" do
        4.times {add_attendee_to_lesson}
        expect(subject.full?).to eq false
        add_attendee_to_lesson
        expect(subject.reload.full?).to eq true
      end
    end
  end
  
end

def add_attendee_to_lesson
  Role.create(user_id: create(:user).id, role: "attendee", rolable_type: "Lesson", rolable_id: subject.id)
end
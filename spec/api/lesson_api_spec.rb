require "spec_helper"

feature "find a lesson" do
  let!(:user) { setup_controller_with_user }
  scenario "see it's glory" do
    lesson = create :lesson
    get lesson_path(lesson)
    expect(response.body).to be_json_eql lesson.to_json
    returns_code 200
  end
  scenario "it isn't found" do
    lesson = create :lesson
    get lesson_path(999)
    expect_json_is_empty(response.body)
    returns_code 404
  end
  # context "that's private" do
  #   scenario "see it's glory private-like" do
  #     lesson = create :lesson, private: true
  #     user.roles.create({role: "attendee", rolable_id: lesson.id, rolable_type: lesson.class.to_s})
  #     get lesson_path(lesson)
  #     expect(response.body).to be_json_eql lesson.to_json
  #     returns_code 200
  #   end
  #   scenario "isn't found even with 'default' role" do
  #     lesson = create :lesson, private: true
  #     user.roles.create({role: "default", rolable_id: lesson.id, rolable_type: lesson.class.to_s})
  #     get lesson_path(lesson)
  #     pending
  #     # expect_not_authorized
  #   end
  #   scenario "isn't found" do
  #     lesson = create :lesson, private: true
  #     get lesson_path(lesson)
  #     expect_json_is_empty(response.body)
  #     returns_code 404
  #   end
  # end
end

feature "lesson creation" do
  before(:each) do
    setup_controller_with_user
  end
  
  scenario "unauthorized user" do
    post lessons_path({lesson: {name: "Some Lesson", description: "Some description"}})
    expect_not_authorized
  end
  
  scenario "authorized user creates lesson" do
    user = setup_controller_with_user create(:user, {role: "business"})
    post lessons_path({lesson: {name: "Some Crazy Lesson", description: "Some description"}})
    expect(json_response["id"]).to eq 1
    expect(user.lessons.first.name).to eq "Some Crazy Lesson"
    expect(user.role_for(user.lessons.first)).to eq "owner"
    returns_code 201
  end
  
  scenario "missing something" do
    setup_controller_with_user create(:user, {role: "business"})
    post businesses_path({lesson: {description: "Some description"}})
    expect(json_response["errors"].keys).to include("name")
    returns_code 422
  end
end

feature "update a lesson" do
  let(:lesson) { create :lesson }
  let(:user) { create :user, role: "business" } # lesson role here is for sanity check
  
  before(:each) do
    setup_controller_with_user user
  end
  
  scenario "user without lesson role" do
    patch lesson_path(lesson, {lesson: {name: "Some Lesson Edited!", description: "Some description"}})
    expect_not_authorized
  end
  
  scenario "user with unauthorized lesson role" do
    user.roles.create({role: "attendee", rolable_id: lesson.id, rolable_type: lesson.class.to_s})
    patch lesson_path(lesson, {lesson: {name: "Some Lesson Edited!", description: "Some description"}})
    expect_not_authorized
  end
  
  context "authorized" do
    before(:each) do
      user.roles.create({role: "owner", rolable_id: lesson.id, rolable_type: lesson.class.to_s})
    end

    # scenario "successfully updated private lesson" do
    #   lesson.update_attribute :private, true
    #   patch lesson_path(lesson, {lesson: {name: "Some Private Lesson Edited!", description: "Some description"}})
    #   expect(json_response["id"]).to eq 1
    #   returns_code 200
    # end
    scenario "successfully updated" do
      patch lesson_path(lesson, {lesson: {name: "Some Lesson Edited!", description: "Some description"}})
      expect(json_response["id"]).to eq 1
      returns_code 200
    end
    
    scenario "blank required attribute" do
      patch lesson_path(lesson, {lesson: {name: ""}})
      expect(lesson.reload.name).to eq "Test Lesson"
      returns_code 422
    end
    
  end
end
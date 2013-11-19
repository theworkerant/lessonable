module Lessonable
  module Lesson
    extend ActiveSupport::Concern
    
    included do
      validates_presence_of :name, :message => "can't be blank"
      validates_presence_of :description, :message => "can't be blank"
      
      has_many :roles, as: :rolable
      has_many :users, through: :roles, source: :user
      scope :public, lambda{where(private: false)}
    end
    
    def attendees
      self.users.select{|user| user.role_for(self) == "attendee"}
    end
    def full?
      attendees.count >= max_occupancy
    end
  end
end
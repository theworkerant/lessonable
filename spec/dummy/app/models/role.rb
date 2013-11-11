class Role < ActiveRecord::Base
  belongs_to :user
  belongs_to :rolable, polymorphic: true 
end

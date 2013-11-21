class Schedulable < ActiveRecord::Base
  belongs_to :schedule
  belongs_to :schedulable, polymorphic: true 
end

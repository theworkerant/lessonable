require "lessonable/engine"

module Lessonable
  extend ActiveSupport::Concern
  
  require "lessonable/models/business"
  require "lessonable/models/user"
  
  require "lessonable/lib/ability"
  require "lessonable/lib/business_ability"
  require "lessonable/lib/subscribable"
end

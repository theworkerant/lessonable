require "lessonable/engine"

module Lessonable
  extend ActiveSupport::Concern
  
  require "lessonable/lib/ability"
  require "lessonable/lib/business_ability"
  require "lessonable/lib/subscribable"
  
  require "lessonable/models/business"
  require "lessonable/models/user"
  require "lessonable/models/subscription"
end

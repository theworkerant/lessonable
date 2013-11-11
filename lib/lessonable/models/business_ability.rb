module Lessonable
  module BusinessAbility
    extend ActiveSupport::Concern
    
    require "cancan"
    include CanCan::Ability
    
    ROLES = %w( owner instructor office )
  end
end
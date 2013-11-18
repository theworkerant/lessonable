class LessonableController < ActionController::Base
  require 'cancan_strong_parameters'
  # include Lessonable::TokenAuthController
  
  respond_to :json
  before_filter :set_format
  
  def current_ability
    current_user.current_ability
  end
  
  rescue_from CanCan::AccessDenied do |exception|
    current_user.errors.add :role, "Not authorized"
    respond_with current_user
  end
    
  rescue_from ActiveRecord::RecordNotFound, with: :four_oh_four
  def four_oh_four
    respond_with "", status: 404
  end
  
  private
  def set_format
    request.format = "json"
  end
  
end

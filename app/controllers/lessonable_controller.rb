class LessonableController < ActionController::Base
  respond_to :json
  before_filter :set_format
  
  rescue_from ActiveRecord::RecordNotFound, with: :four_oh_four
  def four_oh_four
    respond_with "", status: 404
  end
  
  private
  def set_format
    request.format = "json"
  end
end
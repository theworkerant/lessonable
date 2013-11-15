class BusinessesController < LessonableController
  
  load_resource
  before_filter :scope_abilities, only: [:update] 
  authorize_resource
  permit_params :name, :description
  
  # def index
  #   respond_with Business.all
  # end
  def show
    respond_with @business, status: 200
  end
  def create
    @business = Business.new(params[:business])
    if @business.save
      render json: {id: @business.id}, status: 201
    else
      respond_with @business
    end
  end
  def update
    if @business.update_attributes(params[:business])
      render json: {id: @business.id}, status: 200
    else
      respond_with @business
    end
  end
  
  def scope_abilities
    current_user.ability = @business
  end
end
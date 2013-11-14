class BusinessesController < LessonableController
  before_action :set_business, only: [:show]
  
  # def index
  #   respond_with Business.all
  # end
  def show
    respond_with @business, status: 200
  end
  def create
    @business = Business.new(business_params)
    if @business.save
      render json: {id: @business.id}, status: 201
    else
      respond_with @business
    end
  end
  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(business_params)
      render json: {id: @business.id}, status: 200
    else
      respond_with @business
    end
  end
  
  private
  def set_business
    @business = Business.find(params[:id])
  end
  
  def business_params
    params[:business].permit(:name, :description)
  end
  
end
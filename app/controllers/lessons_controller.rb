class LessonsController < LessonableController
  
  before_filter :load_resource, except: [:index, :create]
  before_filter :scope_abilities, only: [:update, :show]
  authorize_resource
  permit_params :name, :description
  
  # def index
  #   respond_with Lesson.all
  # end
  def show
    respond_with @lesson, status: 200
  end
  def create
    @lesson = Lesson.new(params[:lesson])
    if @lesson.save
      current_user.roles.create({role: "owner", rolable_id: @lesson.id, rolable_type: "Lesson"})
      render json: {id: @lesson.id}, status: 201
    else
      respond_with @lesson
    end
  end
  def update
    if @lesson.update_attributes(params[:lesson])
      render json: {id: @lesson.id}, status: 200
    else
      respond_with @lesson
    end
  end
  
  def load_resource
    @lesson = current_user.lessons.find_by(id: params[:id])
    @lesson ||= Lesson.public.find(params[:id])
  end
  def scope_abilities
    current_user.ability = @lesson
  end
end
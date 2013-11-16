class CardsController < LessonableController
  
  # load_and_authorize_resource
  # permit_params :card, :description
  
  # def index
  #   respond_with Business.all
  # end
  # def show
  #   respond_with @card, status: 200
  # end
  def create
    customer = current_user.stripe_customer
    card = customer.cards.create({card: card_params[:token]})
    
    render json: {id: card, last4: card.last4, type: card.type}, status: 201
  end
  # def update
  #   if @card.update_attributes(params[:business])
  #     render json: {id: @card.id}, status: 200
  #   else
  #     respond_with @card
  #   end
  # end
  
  def card_params
    params.require(:card).permit(:token)
  end
  
  rescue_from Stripe::CardError, with: :card_error
  def card_error(exception)
    render json: exception.json_body[:error], status: exception.http_status
  end
end
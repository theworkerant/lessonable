class CardsController < LessonableController

  def create
    card = current_user.stripe_customer.cards.create({card: card_params[:token]})
    render json: {id: card, last4: card.last4, type: card.type}, status: 201
  end
  
  private
  def card_params
    params.require(:card).permit(:token)
  end
  
  rescue_from Stripe::CardError, with: :card_error
  def card_error(exception)
    render json: exception.json_body[:error], status: exception.http_status
  end
end
class SubscriptionsController < LessonableController
  
  def update
    plan = subscription_params[:plan]
    raise cannot_purchase_unlisted(plan) if plan_unlisted?(plan) and current_user.cannot? :purchase_unlisted, Subscription
    current_user.subscribe_to(plan)
    render json: {id: current_user.subscription.id}, status: 200
  end
  def destroy
    at_period_end = !(subscription_params[:at_period_end] == "false")
    current_user.unsubscribe(at_period_end: at_period_end)
    render json: "", status: 200
  end
  
  private
  def plan_unlisted?(plan)
    !Lessonable::Subscribable::ROLE_PLANS.values.flatten.include? plan
  end
  def subscription_params
    params.require(:subscription).permit(:plan, :at_period_end)
  end

  rescue_from Stripe::InvalidRequestError, with: :stripe_error
  def stripe_error(exception)
    render json: exception.json_body[:error], status: exception.http_status
  end
  def cannot_purchase_unlisted(plan)
    message = "No such plan: #{plan}"
    Stripe::InvalidRequestError.new(message, "plan", 400, nil, {error: {message: message, type: "invalid_request_error"}})
  end

end
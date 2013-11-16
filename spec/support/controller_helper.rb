def setup_controller_with_user(controller, user=nil)
  user ||= create :user
  allow_any_instance_of(controller).to receive(:current_user).and_return(user)
  return user
end

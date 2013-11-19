ActiveAdmin.register Subscription do
  index do
    column :user
    column :plan_id
    column :status
    column :current_period_start
    column :current_period_end
    column :canceled_at
  end

  filter :plan_id
  filter :current_period_start
  filter :current_period_end

end

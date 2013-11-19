ActiveAdmin.register Business do
  index do
    column :name
    column :description
    column :user
    default_actions
  end

  filter :name
  filter :user

  form do |f|
    f.inputs "Business Detail" do
      f.input :name
      f.input :description
    end
    f.actions
  end
  controller do
    def permitted_params
      params.permit business: [:name, :description]
    end
  end
end

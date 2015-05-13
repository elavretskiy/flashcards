ActiveAdmin.register Role do
  index do
    selectable_column
    column :id
    column :name
    column :resource_type
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :resource_type
    end
    active_admin_comments
  end

  form do |f|
    inputs do
      input :name

      input :resource_type, as: :select, include_blank: true,
            collection: Rolify.resource_types
    end
    actions
  end

  controller do
    def update
      if role_params[:resource_type].blank?
        params[:role][:resource_type] = nil
      end

      super
    end

    def create
      if role_params[:resource_type].blank?
        params[:role][:resource_type] = nil
      end

      super
    end

    private

    def role_params
      params.require(:role).permit(:name, :resource_type)
    end
  end

  permit_params :name, :resource_type
end

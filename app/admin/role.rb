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
      input :resource_type, as: :select, collection: Rolify.resource_types
    end
    actions
  end

  permit_params :name, :resource_type
end

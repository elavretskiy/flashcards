ActiveAdmin.register Block do
  index do
    selectable_column
    column :id
    column :user
    column :title
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :title
    end
    active_admin_comments
  end

  form do |f|
    inputs do
      input :user
      input :title
    end
    actions
  end

  permit_params :title, :user_id
end

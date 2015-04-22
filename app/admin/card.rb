ActiveAdmin.register Card do
  index do
    selectable_column
    column :id
    column :user
    column :original_text
    column :translated_text
    column :review_date
    actions
  end

  show do
    attributes_table do
      row :id
      row :user
      row :block
      row :original_text
      row :translated_text
      row :review_date
      row :image
    end
    active_admin_comments
  end

  form do |f|
    inputs do
      input :user
      input :block
      input :original_text, as: :string
      input :translated_text, as: :string
      input :review_date
      input :image, label: 'Select image'
      input :image, label: 'Image url', as: :string
    end
    actions
  end

  permit_params :original_text, :translated_text, :review_date,
                :image, :image_cache, :remove_image, :block_id,
                :remote_image_url, :user_id
end

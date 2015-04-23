ActiveAdmin.register User do
  index do
    selectable_column
    column :id

    column 'Role' do |user|
      user.roles.first.name if user.roles.first
    end

    column :email
    column :current_block
    column :locale
    actions
  end

  show do
    attributes_table do
      row :id
      row 'Role' do |user|
        user.roles.first.name if user.roles.first
      end
      row :email
      row :current_block
      row :locale
    end
    active_admin_comments
  end

  form do |f|
    inputs do
      input :roles, label: 'Role',
            as: :select, include_blank: true,
            collection: Role.all.order(name: :asc),
            input_html: {name: 'role_id', multiple: false}

      input :current_block
      input :locale, as: :select, collection: I18n.available_locales
      input :email
      input :password
      input :password_confirmation
    end
    actions
  end

  controller do
    def update
      if role = Role.find_by(id: params[:role_id])
        user = User.find(params[:id])
        user.roles.each { |role| user.remove_role role.name }
        user.add_role role.name
      end
      super
    end

    private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :locale, :current_block_id)
    end
  end

  permit_params :email, :password, :password_confirmation, :locale,
                :current_block_id, :role_id
end

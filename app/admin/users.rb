ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :provider, :uid, :encrypted_password, :reset_password_token, :reset_password_sent_at, :allow_password_change, :remember_created_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :name, :nickname, :image, :email, :tokens
  #
  # or
  #
  # permit_params do
  #   permitted = [:provider, :uid, :encrypted_password, :reset_password_token, :reset_password_sent_at, :allow_password_change, :remember_created_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :name, :nickname, :image, :email, :tokens]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  # 管理画面のインデックス（一覧）に表示する項目
  index do
    selectable_column
    id_column
    column :email
    column :created_at
    actions
  end

  # 検索フィルターの設定
  filter :email
  filter :created_at

  # 編集・新規作成フォームの設定
  form do |f|
    f.inputs do
      f.input :email
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      end
    end
    f.actions
  end

  # 許可するパラメータ（これが無いと更新できません）
  permit_params :email, :password, :password_confirmation
end

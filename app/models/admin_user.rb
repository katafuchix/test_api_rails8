class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  # 管理者一覧で検索（フィルタリング）を許可する項目を定義
  def self.ransackable_attributes(auth_object = nil)
    # 必要最低限の「識別情報」と「タイムスタンプ」に限定します
    ["id", "email", "created_at"]
  end

  # 関連モデルの検索を許可しない場合は空の配列を返します
  def self.ransackable_associations(auth_object = nil)
    []
  end
end

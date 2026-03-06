# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  # 管理画面の検索窓で「検索を許可する項目」を定義
  def self.ransackable_attributes(auth_object = nil)
    # ログインに使用する email や ID、作成日などに限定するのが安全です
    ["id", "email", "name", "nickname", "created_at", "updated_at"]
  end

  # もし関連モデル（Profile等）で検索したい場合は以下も必要になります
  def self.ransackable_associations(auth_object = nil)
    []
  end

end

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if Rails.env.development?

# 管理画面 (ActiveAdmin) 用の管理者作成
# 重複して作成されないように find_or_create_by を使うのが定石です
AdminUser.find_or_create_by!(email: 'admin@example.com') do |admin|
  admin.password = 'password'
  admin.password_confirmation = 'password'
end

# テスト用の一般ユーザーを作成（5人分）
# 収益構造の分析やUIの確認に、ある程度のデータ量が必要になります
5.times do |i|
  User.find_or_create_by!(email: "test_user_#{i}@example.com") do |user|
    user.name = "テストユーザー#{i}"
    user.password = "password123"
    user.password_confirmation = "password123"
    # devise_token_auth用のuidをemailと同じに設定
    user.uid = user.email
    user.provider = 'email'
    user.confirmed_at = Time.current # メール認証をスキップさせる場合
  end
end

puts "初期データの投入が完了しました！"

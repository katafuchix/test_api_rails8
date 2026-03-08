module Api
  class RegistrationsController < BaseController
    # APIなのでCSRFチェックをスキップ（重要）
    skip_before_action :verify_authenticity_token

    def create
      user = User.new(sign_up_params)
      # save! は失敗すると自動で ActiveRecord::RecordInvalid エラーを投げる
      # メッセージも「メールアドレスを入力してください」などが自動でセットされる
      user.save!
      render json: { status: 'success', data: user }, status: :ok
    end

    private

    def sign_up_params
      # require はキーがないと自動で ActionController::ParameterMissing を発生させます
      # 1行で「必須チェック（require）」と「安全な取得（permit）」を完結
      params.require([:email, :password, :password_confirmation]).permit(:email, :password, :password_confirmation)
    end

  end
end

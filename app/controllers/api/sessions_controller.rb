module Api
  class SessionsController < BaseController # 継承元を戻す
    skip_before_action :verify_authenticity_token

    def create
      # 1. ユーザーを特定
      user = User.find_by(email: params[:email])

      # 2. パスワード確認
      if user&.valid_password?(params[:password])
        # 3. トークンを生成（DeviseTokenAuthの仕組みを利用）
        client_id = SecureRandom.urlsafe_base64
        token     = SecureRandom.urlsafe_base64

        user.tokens[client_id] = {
          token: BCrypt::Password.create(token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        user.save!

        # 4. ヘッダーに認証情報をセット
        response.headers['access-token'] = token
        response.headers['client'] = client_id
        response.headers['uid'] = user.uid
        #puts response
        render json: { status: 'success', data: user }
      else
        #render json: { status: 'error', message: '認証失敗' }, status: :unauthorized
        # 辞書から自動でメッセージを取得して投げる
        raise Api::AuthenticationError
      end
    end

    def destroy
      # ログアウト処理（必要に応じて実装）
      render json: { status: 'success' }
    end
  end
end

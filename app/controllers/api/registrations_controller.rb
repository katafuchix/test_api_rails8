module Api
  class RegistrationsController < ApplicationController
    # APIなのでCSRFチェックをスキップ（重要）
    skip_before_action :verify_authenticity_token

    def create
      user = User.new(sign_up_params)
      if user.save
        render json: { status: 'success', data: user }, status: :ok
      else
        render json: { status: 'error', errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
  end
end

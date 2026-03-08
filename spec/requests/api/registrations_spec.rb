require 'swagger_helper'

RSpec.describe 'Registrations API', type: :request do
  path '/api/signup' do
    post 'ユーザー新規登録' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'new_user@example.com' },
          password: { type: :string, example: 'password123' },
          password_confirmation: { type: :string, example: 'password123' }
        },
        required: ['email', 'password', 'password_confirmation']
      }

      response '200', '成功' do
        run_test!
      end
    end
  end
end

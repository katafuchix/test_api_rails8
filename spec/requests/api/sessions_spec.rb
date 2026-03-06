require 'swagger_helper'

RSpec.describe 'Sessions API', type: :request do
  path '/api/login' do
    post 'ログイン実行' do
      tags 'Auth'
      consumes 'application/json'
      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string, example: 'test@example.com' },
          password: { type: :string, example: 'password123' }
        },
        required: ['email', 'password']
      }

      response '200', '成功' do
        header 'access-token', { type: :string }
        run_test!
      end
    end
  end
end

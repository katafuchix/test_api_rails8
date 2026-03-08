module Api
  class BaseController < ActionController::Base
    # APIモードで不要なCSRF保護をスキップ（Deviseとの共存に必須）
    protect_from_forgery with: :null_session
    # ★ これを足す！「AuthenticationError は StandardError の一種ですよ」という宣言
    class Api::AuthenticationError < StandardError; end

    # 1. 各例外に対するステータスコードの厳密な定義
    ERROR_MAPPING = {
      # 400: リクエスト形式の不備（パラメータ不足）
      ActionController::ParameterMissing => :bad_request,

      Api::AuthenticationError => :unauthorized,  # 401

      # 404: リソースが存在しない（DBにIDがない）
      #'ActiveRecord::RecordNotFound' => :not_found,

      # 422: リクエストは届いたが、指定されたIDのデータが存在せず処理不能
      ActiveRecord::RecordNotFound => :unprocessable_entity,

      # 405: 許可されていないメソッド（POSTすべき所にGETなど）
      ActionController::UnknownHttpMethod => :method_not_allowed,

      # 503: サービス利用不可（独自のメンテナンス例外などを想定）
      # 'MyCustomMaintenanceError' => :service_unavailable
    }.freeze

    #アプリ内でエラーが起きたら、この関数を動かせ
    rescue_from StandardError, with: :handle_exception

    private

    def handle_exception(e)
      # マッピングにあるものはそのコード、RoutingErrorは別途404、その他は500
      #status_symbol = if e.is_a?(ActionController::RoutingError)
                        #:not_found
                      #else
                        #ERROR_MAPPING[e.class.name] || :internal_server_error
                      #end

      status_symbol = ERROR_MAPPING[e.class] || :internal_server_error

      # Railsの機能でシンボル(:not_found等)を数値(404等)に変換
      code = Rack::Utils::SYMBOL_TO_STATUS_CODE[status_symbol]

      render json: {
        status: 'error',
        code: code,
        error_type: e.class.name, # エラーの種類を明示して判別を容易にする
        message: e.translated_message
      }, status: status_symbol
    end

    # エラーメッセージ用 現在は使ってない
    def customized_message(e)
      return I18n.t('action_controller.errors.parameter_missing', param: e.param) if e.is_a?(ActionController::ParameterMissing)
      e.message
    end

  end
end

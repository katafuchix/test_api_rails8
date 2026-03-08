# 1. すべての例外の親にデフォルトの振る舞いを定義
class StandardError
  def translated_message
    # ActiveRecord::RecordInvalid など、すでに日本語化されるものはそのまま message を使い、
    # そうでないものも最低限英語のメッセージを返せるようにします。
    self.message
  end
end

# 2. 特定の例外だけ「特注の通訳」を実装（Swiftのオーバーライドに近い感覚）
module ActionController
  class ParameterMissing
    def translated_message
      # 辞書ファイル(ja.yml)から引用
      I18n.t('action_controller.errors.parameter_missing', param: self.param)
    end
  end
end

# 1. パラメーター不足
class ActionController::ParameterMissing
  def translated_message
    I18n.t('action_controller.errors.parameter_missing', param: self.param)
  end
end

# 2. バリデーション失敗（ActiveRecord）
class ActiveRecord::RecordInvalid
  def translated_message
    I18n.t('active_record.errors.record_invalid', message: self.message)
  end
end

# 3. 自作の認証エラー
module Api
  class AuthenticationError < StandardError
    def translated_message
      I18n.t('errors.messages.authentication_failed')
    end
  end
end

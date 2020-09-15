module SessionsHelper

  # ログイン情報を保有する
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # 永続的セッションを記憶する（Userモデル参照）
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_tokne] = user.remember_token
  end
  
  # 永続的セッションを破棄する（Userモデル参照）
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # ログイン情報を破棄する
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
  # ログイン中のユーザーオブジェクトを保持する
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # ログイン中ユーザーの有無を判定
  def logged_in?
    !current_user.nil?
  end
  
    # アクセスしようとしたURLを記憶します。
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # 渡されたユーザーがログイン済みのユーザーであればtrueを返します。
  def current_user?(user)
    user == current_user
  end
end

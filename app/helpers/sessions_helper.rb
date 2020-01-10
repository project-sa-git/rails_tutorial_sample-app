module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  def current_user
    # （元祖）current_user = User.find(session[:user_id])
    # view側でも引き出せるようにインスタンス変数にする
    # （改訂１）@current_user = User.find(session[:user_id])
    # findは失敗したらエラーを返すログイン中にsessionが切れる可能性はあるので、
    # 失敗しても「nil」を返すfind_byを使う。
    # （改訂２）@current_user = User.find_by(id: session[:user_id])
    # @current_user = User.find_by(id: session[:user_id])
    
    # if @current_user.nil?
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user
    # end
    
    # 「or」演算子を使いわずか１行で
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    
    # さらにRubyっぽくして完成
    @current_user ||= User.find_by(id: session[:user_id])
    
  end
  
  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    # キーを指定すると、キーに該当するバリューを削除してくれる
    session.delete(:user_id)
    @current_user = nil
  end
    
end
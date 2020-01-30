module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # def current_user（旧型）
  #   # （元祖）current_user = User.find(session[:user_id])
  #   # view側でも引き出せるようにインスタンス変数にする
  #   # （改訂１）@current_user = User.find(session[:user_id])
  #   # findは失敗したらエラーを返すログイン中にsessionが切れる可能性はあるので、
  #   # 失敗しても「nil」を返すfind_byを使う。
  #   # （改訂２）@current_user = User.find_by(id: session[:user_id])
  #   # @current_user = User.find_by(id: session[:user_id])
    
  #   # if @current_user.nil?
  #   #   @current_user = User.find_by(id: session[:user_id])
  #   # else
  #   #   @current_user
  #   # end
    
  #   # 「or」演算子を使いわずか１行で
  #   # @current_user = @current_user || User.find_by(id: session[:user_id])
    
  #   # さらにRubyっぽくして完成
  #   @current_user ||= User.find_by(id: session[:user_id])
    
  # end
  
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
  
  # ユーザーのセッションを永続的にする（ユーザを安心して復元できるようになった）
  def remember(user) # => DB: remember_digest
    user.remember
    cookies.permanent.signed[:user_id] = user.id #=> coolies(クッキーに指定)、permanent(期限指定20年とする)、signed→暗号化
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # 渡されたユーザーがログイン済みユーザーであればtrueを返す
  def current_user?(user)
    user == current_user
  end
  
  # 記憶トークンcookieに対応するユーザーを返す(新型)
  #=> ユーザオブジェクトが帰るか、nilが帰るか どちらか
  # 現在ログイン中のユーザーを返す (いる場合)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id]) #=> signedで復号化
    # raise       # テストがパスすれば、この部分がテストされていない(マズい)ことがわかる
      user = User.find_by(id: user_id)
      #旧(引数不足) if user && user.authenticated?(cookies[:remember_token])
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  
  # 記憶したURL (もしくはデフォルト値) にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしようとしたURLを覚えておく
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
    
end
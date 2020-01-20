class SessionsController < ApplicationController
  #moduleと対応させる
  # include SessionsHelper
  
  # GET /login
  def new
    # POST /login => create action
  end
  
  # POST /login
  def create
      #まずはUser情報が必要
    user = User.find_by(email:params[:session][:email])
      # Sucess
      #=> User object or false
      # (【rubyの仕組み】falseとnil以外はtrue)
    if user && user.authenticate(params[:session][:password])
      log_in user
      #（旧） remember user #=> SessionsHelperの。 ログイン後にrememberでnew_token発行してDB保存 save to DB
      #  [remember me] チェックボックスの送信結果を処理する
      params[:session][:remember_me] == '1' ? remember(user) : forget(user) #=> （cokies[:token] クッキー追加必要なのでsessionsヘルパーに引数付きremember(user)を追加する）
      redirect_back_or user #=>  フレンドリーフォワーディングを備える  # 旧redirect_to user
    else
      # Failure (sessionモデルがないのでバリデーションが使えない)
      # （旧）　flash[:danger] = 'Invalid email/password combination'
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  
  # DELETE /logout
  def destroy
    log_out if logged_in? # ログイン中の場合のみログアウト(log_outメソッドを実行)する
    # log_out
    redirect_to root_url
  end
  
   # 永続的セッション(Cookie)を破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
  
end

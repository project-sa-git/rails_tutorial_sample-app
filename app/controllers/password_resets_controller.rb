class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # パスワード再設定の有効期限が切れていないか
  
  # GET /password_resets/new
  def new
  end
  
  # POST /password_resets == password_resets_path
  # params[:password_reset][:email] <=== User Input
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  # GET /password_resets/:id/edit
  def edit #=> パスワードを入力してもらうフォームを描画
    @user = User.find_by(email: params[:email]) #=> @user.authenticated?
  end
  
  #PATCH /password_resets/:id
  def update #=> パスワードを再設定する
   if params[:user][:password].empty?                  # 新しいパスワードが空文字列になっていないか (ユーザー情報の編集ではOKだった)
      @user.errors.add(:password, :blank) #=> .add PWが空ならエラーにするメソッド
      render 'edit'
    elsif @user.update_attributes(user_params)          # 新しいパスワードが正しければ、更新する
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # 無効なパスワードであれば失敗させる (失敗した理由も表示する)
    end
  end
  
  private #=> beforeフィルタのため一応慣習化
  
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
  
  def get_user
    @user = User.find_by(email: params[:email])
  end

  # 正しいユーザー(本人)かどうか確認する（unless以下すべての条件取れば有効なユーザー）
  def valid_user
    unless (@user && @user.activated? &&
            @user.authenticated?(:reset, params[:id]))
      flash[:info] = "Invalid password reset link." #=>通知追加
      redirect_to root_url
    end
  end
  
  # トークンが期限切れかどうか確認する
  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "Password reset has expired."
      redirect_to new_password_reset_url
    end
  end
    
end

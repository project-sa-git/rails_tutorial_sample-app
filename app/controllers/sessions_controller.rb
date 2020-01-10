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
      redirect_to user
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
    log_out
    redirect_to root_url
  end
  
end

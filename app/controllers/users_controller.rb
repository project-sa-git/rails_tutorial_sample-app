class UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    # => app/views/users/show.html.erb
    # debugger
  end
  
  def new
    @user = User.new
  end
  
  def create
    # オプション引数はキーワードにシンボルが入ってバリューに値が入ってる集合体
    # 　→　User.new(name: ..., email:, ...)
    # @user.name = params[:user][:name]
    # @user.user = params[:user][:email]
    # @user.password = params[:user][:password]
    # 1行で完結
    @user = User.new(user_params)
      if @user.save #=> Validation
      flash[:success] = "Welcome to the Sample App!"
      # Sucess
      # redirect_to user_path(@user.id)
      # user_pathの引数デフォルトがidなので「.id」省略可、
      # redirect_to user_path(@user)
      # さらにredirect_toのデフォルト挙動としてユーザオブジェクトを渡すとuser_pathになるので
      redirect_to @user
      #GETリクエスト(が右にいく) => "/users/#{@user.id}" => showアクションが動く
      else
      #Failure
      render 'new'
      end
  end
  
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
    
end

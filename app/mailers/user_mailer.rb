class UserMailer < ApplicationMailer

  # def account_activation
  #   @greeting = "Hi"
  #   # (旧)　mail to: "to@example.org" #=> return mail boject
  #   #=> app/views/user_mailer/account_activation.text.erb
  #   #=> app/views/user_mailer/account_activation.html.erb
    
  #   mail to: @user.email #=> mail object
    
  #   # https://hogehoge.com/account_activation/:id/edit
  #   # :id <= @user.activation_tokenを入れる
    
  # end
  
  def account_activation(user)
    @user = user
    mail to: user.email, subject: "Account activation"
  end

  def password_reset
    @greeting = "Hi"
    mail to: "to@example.org"
  end
end

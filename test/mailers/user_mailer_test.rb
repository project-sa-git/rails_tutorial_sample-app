require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:michael)
    user.activation_token = User.new_token #=> 生成したnew_tokenがactivation_tokenに入る
    mail = UserMailer.account_activation(user) #=> 引数にuserでメールobjectが来て変数mailに入って下で照合
    assert_equal "Account activation", mail.subject #=> subject（件名あってるか？）
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from #=> fromあってるか？
    assert_match user.name,               mail.body.encoded #=> メールの文面あってるか？
    assert_match user.activation_token,   mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
  
  test "password_reset" do
    user = users(:michael)
    user.reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal "Password reset", mail.subject
    assert_equal [user.email], mail.to
    assert_equal ["noreply@example.com"], mail.from
    assert_match user.reset_token,        mail.body.encoded
    assert_match CGI.escape(user.email),  mail.body.encoded
  end
end

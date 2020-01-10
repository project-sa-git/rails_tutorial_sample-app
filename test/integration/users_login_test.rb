require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
    
    #成功した時のメソッド
    def setup
        @user = users(:michael)
    end
    
    test "login with invalid information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: "", password: "" } }
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
   
   # 分かるよう下記""の末尾に「 followed by logout（ログアウトもしてるよ）」追加
   test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    # ログインしてるよね？（なくてもok）
    assert is_logged_in?
    # @userにリダイレクトされているかチェックしてされれば以下が動く
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # count:0は「そのリンクが存在しないよね？」のチェックができる
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
    
          # ~~ 下記すべてログアウトテスト分  ~~
    # deleteリクエストをlogout_pathに送りつける
    delete logout_path
    # sessions情報が消えるので、ログインしてないですよね？
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path,      count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
    
  end
  
end

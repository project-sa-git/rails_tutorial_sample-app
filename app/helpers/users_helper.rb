module UsersHelper
  # 引数で与えられたユーザーのGravatar画像を返す
  # def gravatar_for(user, options = { size: 80 }) #=> デフォでsize80追加
  def gravatar_for(user, size: 80) #=> 今風の書き方。下のsize不要
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
       # size = options[:size] #=>変数size ,下記で「?s=#{size}」追加
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end

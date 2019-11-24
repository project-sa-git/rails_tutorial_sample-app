module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  # 「''」　→　「page_title」に何かが入ったら｜の前ex.help
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end

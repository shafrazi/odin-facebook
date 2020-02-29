require "digest/md5"

module ApplicationHelper
  def gravatar_for(user, size)
    unless user.avatar.attached?
      email = user.email
      hash = Digest::MD5.hexdigest(email)
      url = "https://www.gravatar.com/avatar/#{hash}"
    else
      url = url_for user.avatar
    end
    image_tag(url, size: size)
  end
end

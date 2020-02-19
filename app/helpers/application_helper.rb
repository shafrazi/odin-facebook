require "digest/md5"

module ApplicationHelper
  def gravatar_for(user, size)
    email = user.email
    hash = Digest::MD5.hexdigest(email)
    url = "https://www.gravatar.com/avatar/#{hash}"
    image_tag(url, size: size)
  end
end

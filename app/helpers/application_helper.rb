module ApplicationHelper
  def connection_to(social_net, options = {})
    if current_user && current_user.connect_to?(social_net)
      result = "#{social_net}"
    else
      result = link_to social_net, "/auth/#{social_net}"
    end
    content_tag(:li, result, options).html_safe
  end
end

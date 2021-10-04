require 'navigation_helper.rb'

module ApplicationHelper
  include NavigationHelper
  include PostsHelper
  include Private::ConversationsHelper
  include Private::MessagesHelper
  include Group::ConversationsHelper
  include Group::MessagesHelper

  def page_header(text)
    content_for(:page_header) { text.to_s }
  end

  def gravatar_for_user(user, size = 30, title = user.name)
    image_tag gravatar_image_url(user.email, size: 60), title: title, class: 'img-rounded'
  end

  def private_conversations_windows
    params[:controller] != 'messengers' ? @private_conversations_windows : []
  end

  def gravatar_for_person(person, size = 30, title = person.name)
    image_tag gravatar_image_url(person.email_address, size: 60), title: title, class: 'img-rounded'
  end

  def group_conversations_windows
    params[:controller] != 'messengers' ? @group_conversations_windows : []
  end

  def toastr_flash
    flash.each_with_object([]) do |(type, message), flash_messages|
      type = 'success' if type == 'notice' || type == "success"
      type = 'error' if type == 'alert' || type == "error"

      text = "<script>toastr.#{type}('#{message}', '', { closeButton: true, progressBar: true, positionClass: 'toast-top-full-width'  })</script>"
      flash_messages << text.html_safe if message
    end.join("\n").html_safe
  end

end

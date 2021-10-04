module MessagesHelper
  def recipients_options(chosen_recipient)
    s = ''

    if @chosen_recipient
      if params[:recipients]
        intended = Person.find(params[:recipients])
        for i in intended
          s << "<option value='#{i.id}' #{'selected'}>#{i.first_name} #{i.last_name}</option>"
        end
      else
        intended = Person.find(params[:to])
        s << "<option value='#{intended.id}' #{'selected'}>#{intended.first_name} #{intended.last_name}</option>"
      end
    else
      intended = current_user.people.all
      s << "<option value='#{intended.id}' #{'selected'}>#{intended.first_name} #{intended.last_name}</option>"
    end

    s.html_safe
  end
end

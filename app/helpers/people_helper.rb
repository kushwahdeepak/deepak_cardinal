module PeopleHelper
  
  def show_avatar(person)
      render partial: 'people/avatar', object: person
  end
end

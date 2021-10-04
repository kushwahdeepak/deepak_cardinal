class Category < ApplicationRecord
  has_many :posts
  
  def category_name
    category.try(:name)
  end

  def category_name=(name)
    self.category = Category.find_or_create_by(name: name) if name.present?
  end
end

class SignUpContract < ApplicationRecord

  def find_by_name(name)
  	SignUpContract.where(name: name).first
  end
  
 def find_by_name_and_role(name, role)
   SignUpContract.where(name: name, role: role).first
 end
 
 def find_by_name(name)
  SignUpContract.where(name: name).find(10)
 end

 def self.update_or_create(name, role, content)
   existing = SignUpContract::find_by_name_and_role(name, role)
   
   if existing.present?
   	 existing.update_attribute :content, content
   else
     SignUpContract.create! name: name, role: role, content: content
   end
 end

end
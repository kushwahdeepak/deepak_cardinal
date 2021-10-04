class EducationExperience < ApplicationRecord
  
  DOCTOR = ['phd', 'ph.d.', 'ph.d', 'doctorate', 'doctor of philosophy']
  MASTER = ['master', 'masters', 'ma', 'mba', 'ms', 'mtech', 'mca', 'msc']
  BACHELOR = ['bachelor', 'bachelors', 'ba', 'bsc', 'be', 'btech', 'bba', 'bs', 'bca']

  belongs_to :person
  validates_uniqueness_of :school_name, scope: [:person_id]

  include EsEducationExperience

  def update_degree
    if !(DOCTOR & (degree.downcase.split(' ').map{|x| x.gsub(/\W+/, '') })).empty?
      update(degree: Person::DEGREE_DOCTORATE)
    elsif !(BACHELOR & (degree.downcase.split(' ').map{|x| x.gsub(/\W+/, '') })).empty?
      update(degree: Person::DEGREE_BACHELORS)
    elsif !(MASTER & (degree.downcase.split(' ').map{|x| x.gsub(/\W+/, '') })).empty?
      update(degree: Person::DEGREE_MASTERS)        
    end
  end 
end




class AfterSubmittedCandidateController < ApplicationController
  include Wicked::Wizard

  steps :add_user, :add_person, :add_job

  def show
    @user = current_user
    case step
    when :add_person
      @person = Person.new
    end
    render_wizard
  end
end

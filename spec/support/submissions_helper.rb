module SubmissionsHelper
  def create_applicant_stage_transitions(submission)
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::APPLICANTS
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::APPLICANTS
    )
  end

  def create_first_interview_stage_transitions(submission)
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::APPLICANTS
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::FIRST_INTERVIEW
    )
  end

  def create_second_interview_stage_transitions(submission)
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::APPLICANTS
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::FIRST_INTERVIEW
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::SECOND_INTERVIEW
    )
  end

  def create_offer_stage_transitions(submission)
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::APPLICANTS
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::FIRST_INTERVIEW
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::SECOND_INTERVIEW
    )
    create(
      :stage_transition, submission: submission,
      stage: StageTransition::OFFER
    )
  end
end
class JobStageStatus < ApplicationRecord
	belongs_to :job
	MATCH_SCORE_NAME = "person_match_score"

	def self.stage_count(job_id, user_id, submission)
		if submission.present?
			  submission_id = submission.id
		else
	    	submission_id = Job.find(job_id).submissions.ids if job_id.present?
		end
		if submission_id.present?
			lead = total_stage_count(submission_id, 'lead', job_id).count
			first_interview = total_stage_count(submission_id, 'first_interview', job_id).count
			second_interview = total_stage_count(submission_id, 'second_interview', job_id).count
			offer = total_stage_count(submission_id, 'offer', job_id).count
			reject = total_stage_count(submission_id, 'reject', job_id).count
			applicant = total_stage_count(submission_id, 'applicant', job_id).count
			submitted = total_stage_count(submission_id, 'submitted', job_id).count
			recruitor_screen = total_stage_count(submission_id, 'recruitor_screen', job_id).count
			active_candidates = Person.where(active: true).count
			stage = JobStageStatus.where(job_id: job_id)
			if stage.present?
				stage = stage.update_all(active_candidates: active_candidates, submitted: submitted, leads: lead, applicant: applicant, recruiter: recruitor_screen, first_interview: first_interview, second_interview: second_interview, offer: offer, archived: reject)
			else
				stage = JobStageStatus.create(active_candidates: active_candidates, submitted: submitted, job_id: job_id, leads: lead, applicant: applicant, recruiter: recruitor_screen, first_interview: first_interview, second_interview: second_interview, offer: offer, archived: reject)
			end
	  end 
	end

	def self.total_stage_count(submission_id, stage, job_id)
	  candidates_ids = Job.find(job_id).submissions.joins(:person).pluck(:person_id)
	  match_score_value = SystemConfiguration.find_by(name: MATCH_SCORE_NAME)&.value || 0
	  Person.joins("LEFT JOIN match_scores ON match_scores.person_id = people.id AND match_scores.job_id = #{job_id} AND match_scores.score = #{match_score_value}")
	        .joins("LEFT JOIN submissions ON submissions.person_id = people.id AND submissions.job_id = #{job_id}")
			.joins("LEFT JOIN stage_transitions ON stage_transitions.submission_id = submissions.id AND stage_transitions.id = (SELECT MAX(stage_transitions.id) FROM stage_transitions WHERE stage_transitions.submission_id = submissions.id)")
			.where(id: candidates_ids, stage_transitions: { stage: stage }).order("match_scores.score DESC NULLS LAST")
	end

	def as_json(options={})
		super(
			only: JobStageStatus.column_names.map(&:to_sym),
			methods: [:active_candidates]
		)
	end

	private

	def active_candidates
		Person.where(active: true).count
	end
	
end
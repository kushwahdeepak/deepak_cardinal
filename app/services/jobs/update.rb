module Jobs
  class Update
    include Callable

    attr_reader :job, :job_params, :current_user

    def initialize(current_user, job, job_params)
      @job = job
      @job_params = job_params
      @current_user = current_user
    end

    def call
      update_params = job_params.reject { |k| k == 'location_id' }
      update_params.reject! { |k, v| v == "undefined"}
      if job.update(update_params)
        update_locations
        job.update_search_people
        job.__elasticsearch__.index_document
      else
        @errors = job.errors.full_messages.join(' ')
      end
    end

    private

    def update_locations
      return unless job_params[:location_id].present?
      job.jobs_locations.destroy_all
      job_params[:location_id].each do |location_id|
        location = Location.find(location_id)
        job.locations << location if location.present?
      end if job_params[:location_id].present?
    end
  end
end
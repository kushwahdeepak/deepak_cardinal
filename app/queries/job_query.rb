class JobQuery < BaseQuery
  def organization_jobs(organization_id)
    sql = <<-SQL
      SELECT
        jobs.id, 
        jobs.name,
        jobs.description,
        jobs.department,
        jobs.skills,
        jobs.location,
        locations.state,
        locations.city
      FROM jobs
      LEFT JOIN jobs_locations
        ON jobs.id = jobs_locations.job_id
      LEFT JOIN locations
        ON jobs_locations.location_id = locations.id
      WHERE jobs.organization_id = :organization_id AND jobs.active = :is_active AND jobs.status = :is_status
    SQL

    @query = ActiveRecord::Base.send(:sanitize_sql_array, [sql, {organization_id: organization_id, is_active: true,is_status:1}])
  end
end
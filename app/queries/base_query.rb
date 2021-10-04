class BaseQuery
  def initialize
    @query = ''
  end

  def execute
    ActiveRecord::Base.connection.execute(@query).to_a
    rescue ActiveRecord::StatementInvalid
      Rails.logger.debug "invalid sql statement: #{@query}"
  end
end
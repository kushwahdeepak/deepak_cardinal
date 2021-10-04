class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    resp = begin
             uri = URI.parse(value)
             uri.kind_of?(URI::HTTP)
           rescue URI::InvalidURIError
             false
           end

    record.errors[attribute] << (options[:message] || 'Valid URL required') unless resp
  end
end
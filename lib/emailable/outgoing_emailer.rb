require './lib/requestable/http_client'
require './lib/emailable/job_emailer'
require './lib/emailable/user_emailer'
require './lib/emailable/organization_emailer'

module OutgoingEmailer
  include JobEmailer
  include UserEmailer
  include OrganizationEmailer
  include OutgoingEmailsHelper
end
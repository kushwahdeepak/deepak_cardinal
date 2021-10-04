# Used for serialization of modal via blueprinter
require 'oj'

Blueprinter.configure do |config|
  config.generator = Oj # default is JSON
  config.field_default = "N/A"
  config.association_default = {}
end
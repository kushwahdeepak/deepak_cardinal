module LeverPayload
  class Base < ApplicationRecord
    self.abstract_class = true

    def self.table_name_prefix
      'lever_payload_'
    end
  end
end

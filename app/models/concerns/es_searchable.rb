require "elasticsearch/model"

module EsSearchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    after_save :index_document

    after_commit on: [:destroy] do
      __elasticsearch__.delete_document
    end

  end

  class_methods do
    def candidate_organization_rule(organization_id)
      {
        bool: {
          should: [
            {
              bool: {
                must_not: {
                  exists: {
                    field: "organization_id"
                  }
                }
              }
            },
            {
              match_phrase: {
                organization_id: "#{organization_id}"
              }
            }
          ],
          minimum_should_match: 1
        }
      }
    end

    def exact_match(field, value)
      {
        bool: {
          should: [
            {
              match_phrase: {
                field => "#{value}"
              }
            }
          ]
        }
      }
    end
  end

  private

  def index_document
    __elasticsearch__.index_document
  end

  
end

# Job.all.each do |job|
#   job.__elasticsearch__.delete_document
# end


module EsSubmittedCandidateInfo
  extend ActiveSupport::Concern

  included do
    include EsSearchable

    settings do
      mappings dynamic: false do
        indexes :candidate_id, type: :integer
        indexes :search_text, type: :text, analyzer: :english
        indexes :keyword, type: :text, analyzer: :english
        indexes :skills, type: :text, analyzer: :english
        indexes :location, type: :text, analyzer: :english
        indexes :company_names, type: :text, analyzer: :english
        indexes :title, type: :text, analyzer: :english
        indexes :school, type: :text, analyzer: :english
        indexes :first_name, type: :text, analyzer: :english
        indexes :last_name, type: :text, analyzer: :english
        indexes :degree, type: :text, analyzer: :english
        indexes :discipline, type: :text, analyzer: :english
        indexes :email_address, type: :text, analyzer: :english
        indexes :phone_number, type: :text, analyzer: :english
        indexes :tags, type: :text, analyzer: :english
        indexes :public, type: :text, analyzer: :english
        indexes :organization_id, type: :keyword
        indexes :top_school, type: :boolean
        indexes :top_company, type: :boolean
        indexes :active, type: :boolean
        indexes :match_score, type: :float
        indexes :candidate_stage, type: :text
        indexes :job_id, type: :integer
      end
    end

    def as_indexed_json(options = {})
      as_json(
        only: [ :search_text, :keyword, :skills, :location, :company_names, :title, :school, :first_name, :last_name, :degree,
                :discipline, :email_address, :phone_number, :tags, :public, :organization_id, :top_school, :top_company, :active,
                :match_score, :candidate_stage, :job_id, :candidate_id
              ]
      )
    end

  end

  class_methods do
    def search(query)
      __elasticsearch__.search(
        {
          size: 100,

          query: {
            multi_match: {
              query: query,
              fields: [ 'search_text', 'keyword', 'skills', 'location', 'company_names', 'title', 'school', 'first_name', 'last_name', 'degree',
                        'discipline', 'email_address', 'phone_number', 'tags', 'public', 'organization_id', 'top_school', 'top_company', 'active'],
            }
          },
          sort: {
            match_score: {
              order: :desc
            }
          }
        }
      )
    end

    def search_candidate_with_filters(options = {}, match_score_value)
      __elasticsearch__.search(
        {
          query: {
            bool: {
              must: self.search_match_query(options, match_score_value)
            }
          },

          size: 1000,

          sort: {
            match_score: {
              order: :desc
            }
          }
        }
      )
    end

    def match_all_filter
      __elasticsearch__.search(
        {
          size: 100,

          query: {
            match_all: {}
          },

          sort: {
            match_score: {
              order: :desc
            }
          }
        }
      )
    end

    def search_match_query(options, match_score_value)
      query = []

      if options[:keyword].present?
        query << {
          multi_match: {
            query: options[:keyword],
            fields: ['location', 'first_name', 'last_name', 'tags', 'title', 'email_address', 'skills', 'school', 'company_names'],
          }
        }

        options.delete(:keyword)
      end

      query << {
        range:{
          match_score: {
            lte: 100.0,
            gte: match_score_value
          }
        }
      }

      query << {
        regexp:{
          skills: ".+"
        }
      }

      if options[:phone_number_available].present?
        query << {
          regexp: {
            phone_number: ".+"
          }
        }
        options.delete(:phone_number)
      end

      if options[:names].present?
        query << {
          multi_match: {
            query: options[:names],
            fields: ['first_name', 'last_name']
          }
        }
        options.delete(:names)
      end

      if options[:email_address].present?
        query << {
          bool: {
            should: [
              {
                match_phrase: {
                  email_address: "#{options[:email_address]}"
                }
              }
            ]
          }
        }

        options.delete(:email_address)
      end

      if options[:candidate_id].present?
        query << {
          bool: {
            filter: {
              terms: {
                candidate_id: options[:candidate_id]
              }
            }
          }
        }
        options.delete(:candidate_id)
      end

      # to show only candidate whose stage is lead
      if options[:job_id].present?
        query << {
          match: {
            candidate_stage: "lead"
          }
        }
      end

      # we are doing to only fetch candidate who have same organization_id as current user
      # and whose organization_id is nil

      if options[:organization_id].present?
        query << SubmittedCandidateInfo.candidate_organization_rule(options[:organization_id])
        options.delete(:organization_id)
      end

      if options.present?
        options.each do |key, value|
          next if key == :keyword || key == :email_address || key == :phone_number || key == :candidate_id || key == :organization_id

          query << { match: { "#{key}": value }}
        end
      end
      query
    end

  end
end

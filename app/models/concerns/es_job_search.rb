
module EsJobSearch
  extend ActiveSupport::Concern

  included do
    include EsSearchable

    settings do
      mappings dynamic: false do
        indexes :id, type: :integer
        indexes :skills, type: :text, analyzer: :english
        indexes :pref_skills, type: :text, analyzer: :english
        indexes :company_names, type: :text, analyzer: :english
        indexes :description, type: :text, analyzer: :english
        indexes :portalcompanyname, type: :text, analyzer: :english
        indexes :name, type: :text, analyzer: :english
        indexes :creator_id, type: :integer
        indexes :experience_years, type: :integer
        indexes :organization_id, type: :keyword
        indexes :active, type: :boolean
        indexes :location, type: :text, analyzer: :english
        indexes :get_organization_name, type: :text, analyzer: :english
        indexes :status, type: :text, analyzer: :english
      end
    end

    def as_indexed_json(options = {})
      as_json(
        only: [ :id, :skills, :pref_skills, :company_names, :description, :portalcompanyname, :name, :creator_id, :experience_years, :organization_id, :active, :location, :status],
        methods: [:get_organization_name]
      )
    end

  end

  class_methods do
    def search(query)
      __elasticsearch__.search(
        {
          size: 10000,

          query: {
            multi_match: {
              query: query,
              fields: [ 'skills^2', 'pref_skills', 'name^3', 'company_names','portalcompanyname', 'location','get_organization_name'],
            }
          },
          sort: {
            id: {
              order: :desc
            }
          }
        }
      )
    end

    def search_jobs_with_filters(options = {})
      default_filter = {
        active: true,
        status: 'active'
      }

      options.merge!(default_filter)

      __elasticsearch__.search(
        {
          query: {
            bool: {
              must: self.search_match_query(options),
            }
          },

          size: 10000,

          sort: {
            id: {
              order: :desc
            }
          }
        }
      )
    end

    def match_all_filter
      __elasticsearch__.search(
        {
          size: 10000,

          query: {
            bool: {
              must: self.status_active_filter()
            }
          },

          sort: {
            id: {
              order: :desc
            }
          }
        }
      )
    end

    def search_match_query(options)
      query = []
      
#       query << { match: { status: "active" } }
#       query << { match: { active: true } }
      if options[:keyword].present?
        query << {
          multi_match: {
            query: options[:keyword],
            fields: ['skills^2', 'pref_skills', 'name^3', 'company_names','portalcompanyname','location','get_organization_name'],
          }
        }

        options.delete(:keyword)
      end

      if options[:skills].present? || options[:pref_skills].present?
        query << { 
          match: { 
            skills: options[:skills]
          } 
        }
        options.delete(:skills)
      end
      
      if options[:portalcompanyname].present? 
        query << { 
          match: { 
            "get_organization_name": options[:portalcompanyname]
          } 
        }
        options.delete(:portalcompanyname)
      end

      if options[:locations].present?
        query << { 
          match: { 
              location: options[:locations]
            }
          }
        options.delete(:locations)
      end

      if options[:job_keyword].present?
        query << { match: { name: options[:job_keyword] } }
        options.delete(:job_keyword)
      end
      
      if options[:experience_years].present?
        query << experience_query(options)
        options.delete(:experience_years)
      end

      if options.present?
        options.each do |key, value|
          # if key == 'keyword' || key == 'company_names' || key == 'experience_years' ||  key == 'job_keyword'
           query << { match: { "#{key}": value }}
          # end
        end
      end

      query
    end

    def experience_query(options)
      if options[:experience_years] == '0-0'
        query = {
          gte: 0,
          lt: 1,
          relation: "within"
        }

      else

        exp_yrs = options[:experience_years].split("-")

        query = {
          gte: exp_yrs[0].to_i,
          lte: exp_yrs[1].to_i,
          relation: "within"
        }
      end


      {
        range: {
          experience_years: query
        }
      }
    end

    def status_active_filter()
      query = []
      query << { match: { status: "active" } }
      query << { match: { active: true } }
      query
    end

  end
end

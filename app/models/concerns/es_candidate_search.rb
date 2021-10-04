
module EsCandidateSearch
  extend ActiveSupport::Concern

  included do
    include EsSearchable

    settings do
      mappings dynamic: false do
        indexes :id, type: :integer
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
        indexes :get_education_experiences, type: :text, analyzer: :english
        indexes :get_company_names, type: :text, analyzer: :english
      end
    end

    def as_indexed_json(options = {})
      as_json(
        only: [ :id, :search_text, :keyword, :skills, :location, :company_names, :title, :school, :first_name, :last_name, :degree,
                :discipline, :email_address, :phone_number, :tags, :public, :organization_id, :top_school, :top_company, :active],
        methods: [:get_education_experiences, :get_company_names]
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
              'discipline', 'email_address', 'phone_number', 'tags', 'public', 'organization_id', 'top_school', 'top_company'],
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

    def search_candidate_with_filters(options = {})
      __elasticsearch__.search(
        {
          query: {
            bool: {
              must: self.search_match_query(options),
            }
          },

          size: 1000,

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
          size: 100,

          query: {
            match_all: {}
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
      if options[:keyword].present?
        parse_keyword = options[:keyword]
        if parse_keyword&.downcase&.include?(" or ")
             words = parse_keyword.downcase
             words = parse_keyword.split(" or ")
             attribute = []
              words.each do |name|
                attribute << {
                  multi_match: {
                    query: name,
                    fields: ['skills', 'title']
                  }
                }
              end
              query << {
                bool: {
                  should: attribute
                }
              }
            options.delete(words) 
        elsif parse_keyword&.downcase&.include?(" and ")
              query <<  {"bool":{"must":[{"multi_match": {"query": options[:keyword],type: 'cross_fields',"fields":["skills", "title"], operator: "and"}}]}}
              options.delete(:keyword)
        elsif parse_keyword&.downcase&.include?(" not ")
              words = parse_keyword.downcase
              words = parse_keyword.split(" not ")
              words[0]
              words[1]
              if words[0].present?
                query << {
                    multi_match: {
                      query: words[0],
                      fields: ['skills', 'title']
                    }
                }
                options.delete(words[0]) 
              end
              if words[1].present?
                query << {
                  bool: {
                    must_not: [
                      {match: {skills: words[1]}},
                      {match: {title: words[1]}}
                    ]
                  }
                }
              options.delete(words[1]) 
            end
        else  query << {
            multi_match: {
              query: options[:keyword],
              fields: ['location', 'first_name', 'last_name', 'tags', 'title', 'email_address', 'skills', 'school', 'company_names'],
            }
          }
          options.delete(:keyword)
        end
      end

      # this query work to remove candidate who don't have skills

      query << {
        bool: {
          must: {
            exists: {
              field: "skills"
            }
          },
          must_not: {
            term: {
              skills: ""
            }
          }
        }
      }

      if options[:phone_number].present?
        query << {
          regexp: {
            phone_number: ".+"
          }
        }
        options.delete(:phone_number)
      end

      if options[:names].present?
        attribute = []
        options[:names].split(',').each do |name|
          attribute << {
            multi_match: {
              query: name,
              fields: ['first_name', 'last_name']
            }
          }
        end
        query << {
          bool: {
            should: attribute
          }
        }
        options.delete(:names)
      end

      if options[:id].present?
        query << {
          bool: {
            filter: {
              terms: {
                id: options[:id]
              }
            }
          }
        }
        options.delete(:id)
      end

      if options[:email_address].present?
        attribute = [] 
        options[:email_address].split(',').each do |email|
          attribute << {
            match_phrase: {
              email_address: email
            }
          }
        end
        query << {
          bool: {
            should: attribute
          }
        }
        options.delete(:email_address)
      end

      if options[:email_type].present? && (options[:email_type] == "Personal" || options[:email_type] == "Company")
        type = 'gmail.com'
        query <<
          if options[:email_type] == "Personal"
            {
              bool: {
                must: [
                  {
                    match_phrase: {
                      email_address: type
                    }
                  }
                ]
              }
            }
          else
            {
              bool: {
                must_not: {
                  match: {
                    email_address: type
                  }
                }
              }
            }
          end
        options.delete(:email_type)
      end

      if options[:school].present?
        attribute = []
        options[:school].split(',').each do |school|
          person_ids = EducationExperience.search_candidate_with_filters(school)&.records&.all&.pluck(:person_id)&.uniq
          attribute << {
            match_phrase: {
              school: school
            }
          }
          attribute << {
            ids: {
              type: "_doc",
              values: person_ids
            }
          }
        end

        query << {
          bool: {
            should: attribute,
            minimum_should_match: 1
          }
        } 
      end

      if options[:degree].present?
        query << { match: { "get_education_experiences": options[:degree] } }
        options.delete(:degree)
      end

      # we are doing to only fetch candidate who have same organization_id as current user
      # and whose organization_id is nil
      if options[:organization_id].present?
        query << Person.candidate_organization_rule(options[:organization_id])
        options.delete(:organization_id)
      end

      if options.present?
        options.each do |key, value|
          if key == :skills || key == :company_names || key == :title || key == :location

            attribute = []
            value.split(",").each do |a|
              # attribute << { match_phrase: { key => a } }
              if key == :company_names
                attribute << { match: { 'get_company_names': a } }
                #TODO: remove this once we got proper data in our database
                attribute << { match_phrase: { title: a } }
              elsif key == :location
                state = Location::STATE[a.downcase]
                attribute << { match_phrase: { key => state } } if state
                attribute << { match_phrase: { key => a } }
              else
                attribute << { match_phrase: {key => a}}  
              end
            end
            query << {
              bool: {
                should: attribute
              }
            }
            options.delete(key)
          end
        end
      end

      if options.present?
        options.each do |key, value|
          next if key == :keyword  || key == :email_address || key == :phone_number || key == :id || key == :organization_id || key == :school
          query << { match: { "#{key}" => value } }
        end
      end

      query
    end
  end
end

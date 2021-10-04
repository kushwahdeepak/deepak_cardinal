module EsEducationExperience
    extend ActiveSupport::Concern
  
    included do
      include EsSearchable
  
      settings do
        mappings dynamic: false do
          indexes :id, type: :integer
          indexes :school_name, type: :text, analyzer: :english
          indexes :person_id, type: :integer
        end
      end
    end

    def as_indexed_json(options = {})
        as_json(
            only: [ :id, :school_name, :person_id]     
        )
    end

    class_methods do 
        def search(search)
            __elasticsearch__.search(
                query: {
                    multi_match: {
                        query: search,
                        fields: ['school_name', 'id', 'person_id']
                    }
                }
            )
        end

        def search_candidate_with_filters(school_name)
            __elasticsearch__.search(
                {
                    query: {
                        bool: {
                            must: { 
                                bool: {
                                    should: [
                                        {
                                            match_phrase: {
                                                school_name: school_name
                                            }
                                        }
                                    ]
                                }
                            }
                        }   
                    }
                }
            ) 
        end
    end
end      
  
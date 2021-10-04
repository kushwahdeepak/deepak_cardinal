json.array!(@submitted_candidates) do |submitted_candidate|
  json.extract! submitted_candidate, :id, :name, :colour, :owner_name, :identifying_characteristics, :special_instructions
  json.url pet_url(submitted_candidate, format: :json)
end

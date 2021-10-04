desc "Remove searches older than a month"
task remove_old_searches: :environment do
  Search.delete_all ["created_at < ?", 1.month.ago]
end

desc "convert original job's location info to Location table"
task convert_portalcity_to_location: :environment do
  # portalcity = ["San Francisco", "los angeles metro area", "San Jose, California, United States", "", "Denver, CO", "Austin, TX", "San Francisco", "San Francisco", "San Francisco", "Remote", "Remote", "Remote", "Remote", "Redwood City", "Redwood City", "Austin, TX", "San Francisco", "Columbus, Ohio", "New York", "Los Angeles", "Los Angeles", "Los Angeles", "Los Angeles", "San Francisco", "Remote or Austin, TX", "http://zibo.co", "Mountain View, CA", "Mountain View, CA", "Palo Alto , CA", "Palo Alto , CA", "Santa Clara , CA", "San Francisco , CA", "Jacksonsville, FL ", "Charlotte, North Carolina ", "San Diego, San Francisco, Guadalajara-Mexico", "San Francisco", "Richmond", "Washington DC", "Baltimore", "Remote", "San Diego", "Seattle, WA", "Denver, CO", "Seattle, WA", "San Diego", "Seattle, WA", "San Diego", "Los Angeles", "Mountain View, CA", "San Francisco, CA", "Jersey City, NJ", "Palo Alto, CA", "Palo Alto, CA", "Palo Alto, CA", "San Francisco", "Los Angeles", "Dallas TX", "San Antonio TX", "Dallas TX", "San Antonio TX", "Dallas TX", "Palo Alto, CA", "Palo Alto, CA", "Palo Alto, CA", "Los Angeles", " Palo Alto", "Los Angeles", "New York City", "Orlando, FL", "Boulder, CO", "Durham, NC", "New York City", "Austin, TX", "Boulder, CO", "Durham, NC", "Austin, TX", "New York", "Atlanta, GA", "Atlanta, GA", "Atlanta, GA", "Boulder, CO", "San Francisco, CA", "San Antonio, TX", "San Antonio, TX", "New York", "San Antonio, TX", "Austin, TX", "San Antonio, TX", "Reston, VA", "New York", "Baltimore, MD", "San Antonio, TX", "Ann Arbor, Michigan", "Boulder, CO", "Ithaca, NY ", "Santa Clara", "San Francisco", "Milpitas", "Palo Alto, CA", "Seattle, WA", "Seattle, WA", "Seattle, WA", "Hoboken, NJ", "Hoboken, NJ", "Greenland, NH", "Austin, TX", "Austin, TX", "San Francisco, Bay Area", "San Francisco, Bay Area", "San Francisco, Bay Area", "San Francisco, Bay Area", "Seattle, WA ", "Seattle, WA", "San Francisco, CA", "San Jose, Ca", "Mountain View, CA", "Raleigh, NC", "San Francisco, CA", "Tacoma, WA", "Jersey Ciy, NJ", "Seattle or Remote", "Portland, OR", "San Francisco, CA", "US", "Santa Clare", "Palo Alto", "Newark, CA", "San Francisco Bay Area", "Los Angeles, CA", "Berkeley, CA", "Newark, NJ", "San Francisco Bay Area", "New York", "San Francisco", "New York", "San Francisco Bay Area", "San Francisco Bay Area, California", "New York City Metropolitan Area ", "Jersey City", "Brooklyn, New York", "New Jerse", "New York City", "Santa Monica", "Culver City", "San Francisco Bay Area", "San Diego", "New Jersey", "Remote, United States", "Remote, United States", "Remote, United States", "Remote, United States", "Remote, United States", "Los Angeles", "San Francisco Bay Area", "Los Angeles", "Seattle, Washington", "Greater Austin, TX", "King of Prussia, PA", "Jersey City", "Palo Alto", "San Jose", "Los Angeles", "Greater Seattle Area", "SF Bay Area", "NYC Metro Area", "SF Bay Area", "New York Metropolitan Area", "Greater Seattle Area", "NYC Metropolitan Area", "SF Bay Area", "Greater Seattle Area", "NYC Metropolitan Area", "SF Bay Area", "New York Metropolitan Area", "Greater Seattle Area", "New York City Metropolitan Area", "San Francisco Bay Area", "New York City Metropolitan Area", "Greater Seattle Area", "Montreal", "San Francisco Bay Area", "New York Metropolitan Area", "Palo Alto", "San Francisco Bay Area, California", "Palo Alto", "Seattle, Washington", "San Francisco Bay Area, California", "Seattle, Washington", "Austin, Texas", "Remote, United States", "Houston, Texas", "San Francisco Bay Area", "Los Angeles", "San Francisco Bay Area", "Los Angeles", "San Francisco Bay Area", "San Francisco Bay Area", "Los Angeles", "San Francisco Bay Area", "Mountain View, CA", "San Francisco Bay Area", "Mountain View, CA", "San Francisco Bay Area", "Mountain View, CA", "San Mateo", "San Mateo", "San Francisco Bay Area", "Palo Alto", "San Francisco Bay Area", "Washington DC", "Remote, United States", "San Francisco Bay Area", "Boston, Massachusetts", "Stamford", "New York", "New Jersey", "Miami, Florida", "New York City", "Palo Alto", "Greater Pittsburgh Area", "Palo Alto", "New York", "Texas", "California", "Washington", "Remote, United States", "Los Angeles", "San Francisco Bay Area", "Mountain View, California", "San Francisco Bay Area", "Los Angeles", "San Francisco Bay Area", "Mountain View, California", "San Francisco Bay Area", "San Francisco Bay Area", "San Francisco Bay Area", "Washington DC", "Remote, US", "San Francisco Bay Area", "San Francisco Bay Area", "Palo Alto", "New York", "San Francisco Bay Area", "Palo Alto", "New York", "Toronto", "Vancouver", "Austin, TX", "Miami, Florida", "Minneapolis", "Chicago", "Atlanta, GA", "Austin, Texas", "Los Angeles, CA", "San Francisco Bay Area", "Austin, Texas", "Los Angeles, CA", "San Francisco Bay Area", "Santa Clara County, California", "San Mateo, California", "San Francisco Bay Area", "Palo Alto", "New York City", "San Francisco, CA", "new york", "Seattle, Wa", "", "", "", "Austin, Texas", "Austin, Texas", "El Segundo, CA", "Aurora, CO", "San Francisco", "Palo Alto", "San Jose", "Phoenix, Arizona", "Austin, Texas", "Boston, Massachusetts", "Phoenix, Arizona", "Boston, Ma", "Greater Chicago Area", "San Francisco", "Oakland", "Seattle, Washington", "Los Angeles, California", "Portland, Oregon", "New York City, United States", "San Francisco", "Washington D.C", "Seattle, Washington", "Pennsylvania", "Philadelphia", "Los Angeles Metropolitan Area", "San Francisco Bay Area", "Los Angeles", "", "Boston", "Seattle", "Oakland", "Boston", "San Franciso Bay Area, CA", "Richmond, CA ", "Seattle, WA", "San Francisco Bay Area, CA", "Seattle, WA,", "Austin, TX", "Ft. Meade (Annapolis Junction),", "Washington DC metro area", "Austin, TX", "Boston MA", "Greater Chicago Area", "Seattle, WA", "Phoenix, AZ", "Boulder, CO", "Austin, TX", "Fremont, CA", "San Jose, CA", "Oakland, CA", "Remote", "San Diego, CA", "Santa Monica, CA", "Los Angeles Metropolitan Area", "San Francisco Bay Area", "Austin, TX", "Austin Metropolitan Area.", "San Jose, CA", "San Francisco Bay Area, CA", "Boston, MA", "Austin, TX", "Seattle, WA", "New York City, NY", "San Francisco Bay Area, CA", "Boston, MA", "Austin, TX,", "Seattle, WA", "New York City, NY", "Palo Alto", "Remote", "Austin, TX", "Chicago, IL", "New York City, NY", "Princeton, NJ", "Los Angeles, California", "Austin, Texas", "San Francisco Bay Area", "Seattle, WA", "Austin, TX", "Fremont California", "Fremont CA", "New York City", "Dallas", "Quantico, VA", "Washington DC metro area", "Las Vegas", "Los Angeles ", "Las Vegas", " Los Angeles Metropolitan Area", "San Francisco Bay Area", "San Francisco Bay Area", "Remote", "Florida", "Austin", "Toronto", "New York", "Seattle", "Los Angeles", "San Francisco", "Miami", "San Diego ", "Los Angeles Metropolitan Area. ", "Greater Seattle Area. ", "San Francisco Bay Area. ", "Phoenix, AZ.", "Reston, virginia", "Reston, virginia", "Seattle", "Seattle", "Seattle", "Boca Raton, Florida", " New York", "San Francisco", "Austin", "Miami", "San Diego", "San Francisco", "Palo Alto, California", "San Jose, California", "Los Angeles", "Atlanta, Georgia", "San Francisco, California", "Palo Alto", "Oakland, CA", "San Francisco, California", "Palo Alto", "Oakland, CA", "Minneapolis", "Greater Seattle Area", "Greater Boston Area", "Minneapolis"]
  # portalcity.each do |org_location|
  Job.all.find_each(batch_size: 50) do |job|
    org_location = job.portalcity
    next unless org_location.present?
    sub_locations = org_location.split(",")
    if sub_locations.length == 1
      location_name = sub_locations[0].strip
      #1. case of only country name
      location_name = CS.countries[location_name.upcase.to_sym] || location_name
      location = Location.where('LOWER(country) = ?', location_name.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location}' -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end
      
      #2. case of only state name in United States
      location_name = CS.states(:US)[location_name.upcase.to_sym] || location_name
      location = Location.where(country: 'United States')
                        .where('LOWER(state) = ?', location_name.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location}' -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end

      #3. case of only city name in United States
      location = Location.where(country: 'United States')
                        .where('LOWER(city) = ?', location_name.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location}' -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end
    end

    if sub_locations.length == 2
      first_location = sub_locations[0].strip
      second_location = sub_locations[1].strip
      #1. case of state + country
      second_location = CS.countries[second_location.upcase.to_sym] || second_location
      first_location = CS.states(CS.countries.key(second_location))[first_location.upcase.to_sym] || first_location
      location = Location.where('LOWER(country) = ?', second_location.downcase)
                        .where('LOWER(state) = ?', first_location.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location}' -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end

      #2. case of city + state in United States 
      second_location = CS.states(:US)[second_location.upcase.to_sym] || second_location
      location = Location.where('LOWER(state) = ?', second_location.downcase)
                        .where('LOWER(city) = ?', first_location.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location}' -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end
    end

    if sub_locations.length == 3
      city_location = sub_locations[0].strip
      state_location = sub_locations[1].strip
      country_location = sub_locations[2].strip
      # case of city + state + country
      country_location = CS.countries[country_location.upcase.to_sym] || country_location
      state_location = CS.states(CS.countries.key(country_location))[state_location.upcase.to_sym] || state_location
      location = Location.where('LOWER(country) = ?', country_location.downcase)
                        .where('LOWER(state) = ?', state_location.downcase)
                        .where('LOWER(city) = ?', city_location.downcase).first
      if location.present?
        next if job.locations.pluck(:id).include?(location.id)
        puts "Success '#{org_location} -> '#{location.city} #{location.state} #{location.country}'"
        location.jobs << job
        next
      end
    end
    puts "Failed '#{org_location}', processing with 'Other'"
    location = Location.where(country: 'Other').first
    next if job.locations.pluck(:id).include?(location.id)
    location.jobs << job
  end
end
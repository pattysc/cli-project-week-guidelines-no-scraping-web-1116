class ExampleApi

  attr_reader :url, :death_cause, :death_data, :death_number

  def initialize(url)
    @url = url
    @death_data = JSON.parse(RestClient.get(url))
  end

  #"Asian and Pacific Islander"
  #"Black Non-Hispanic"
  #"Hispanic"
  #"Not Stated"
  #"Other Race/Ethnicity"
  #"White Non-Hispanic"


  def death_number (death_cause)
    death_count = 0
    @death_data.each do |death|
      if death["leading_cause"].downcase.include?(death_cause)
        death_count += death["deaths"].to_i
      end
    end
    death_count
  end

  def top_gender(gender)
    ethnicity_hash = {}
    @death_data.each do |death|
      if death["sex"].downcase == gender
        if ethnicity_hash["#{death["leading_cause"]}"]
          ethnicity_hash["#{death["leading_cause"]}"] += death["deaths"].to_i
        else
          ethnicity_hash["#{death["leading_cause"]}"] = death["deaths"].to_i
        end
      end
    end
    # puts ethnicity_hash

    ethnicity_hash = ethnicity_hash.sort_by {|key, value| value}.reverse
    if gender == "f"
      puts "\n"
      puts "Top Five diseases for Females"
    else
      puts "\n"
      puts "Top Five diseases for Males"
    end
    ethnicity_hash.each_with_index do |(key, value), index|
      if index < 5 
        puts "\n"
        puts "#{index+1}. #{key}: #{value.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse} deaths"
      end
    end
  end

  def top_five(ethnicity)
    ethnicity_hash = {}
    @death_data.each do |death|
      if death["race_ethnicity"].downcase.include?(ethnicity)
        if ethnicity_hash["#{death["leading_cause"]}"]
          ethnicity_hash["#{death["leading_cause"]}"] += death["deaths"].to_i
        else
          ethnicity_hash["#{death["leading_cause"]}"] = death["deaths"].to_i
        end
      end
    end
    # puts ethnicity_hash

    ethnicity_hash = ethnicity_hash.sort_by {|key, value| value}.reverse
    puts "\n"
    puts "Top Five diseases of #{ethnicity.capitalize} people"
    ethnicity_hash.each_with_index do |(key, value), index|
      if index < 5 
        puts "\n"
        puts "#{index+1}. #{key}: #{value.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse} deaths"
      end
    end

  end

end

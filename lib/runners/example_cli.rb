class ExampleCLI

  def call
    puts "\n"
    puts "This app researches death rates in NYC from 2007-2014.\n\nCurrently you can find total number of deaths by disease, top deaths by ethnicity, or the most common deaths by gender."
    puts "\n"
    run_all
  end

#Get user input
#Parse input into array
#hit NY Open data death
#take data and iterate through data
#display nicely


  def get_user_input
    gets.chomp.strip.downcase
  end

  def run_all
    print "Please select one of the following letter options(enter letter of desired choice):\n
    A) Find the number of deaths by disease\n
    B) Find Top 5 deaths by ethnicity\n
    C) Find Top 5 deaths by gender\n
    D) Help me!\n
    E) Get me out of here (exit)\n
    Input: "
    option = get_user_input
    case option
    when "a"
      run_cause_of_death
    when "b"
      run_top_five
    when "c"
      run_top_gender
    when "d"
      help
    when "e"
      exit
    else
      puts "Invalid entry - please enter a single letter option."
      run_all
    end
  end

  def run_top_gender
    puts "\n"
    print "Please give us a gender (M/F): "
    gender = get_user_input
    if gender == "m"
      puts "The gender you chose is Male, I am searching..."
    elsif gender == "f"
      puts  "The gender you chose is Female, I am searching..."
    else
      puts "Try again"
      run_top_gender
    end
    search_top_gender(gender)
  end

  def get_hash
      url = "https://data.cityofnewyork.us/resource/uvxr-2jwn.json"
      death_hash = ExampleApi.new(url)
  end

  def run_cause_of_death
    puts "\n"
    print "Please input cause of death:"
    input = get_user_input
    if input == "help"
      help
    elsif input == "exit"
      exit
    else
      search_cause_of_death(input)
    end
  end

  def run_top_five
    puts "\n"
    print "Please choose an ethnicity that you'd like to find Top 5 causes of death for - please enter a single letter option: \n
      A) Asian and Pacific Islander\n
      B) Black Non-Hispanic \n
      C) Hispanic \n
      D) White Non-Hispanic \n
      E) Other Race/ Ethnicity \n
      F) Not Stated/Unknown\n"
    print "Input: "
    ethnicity = get_user_input
    case ethnicity
    when "a"
      ethnicity = "Asian and Pacific Islander"
    when "b"
      ethnicity = "Black Non-Hispanic"
    when "c"
      ethnicity = "Hispanic"
    when "d"
      ethnicity = "White Non-Hispanic"
    when "e"
      ethnicity = "Other Race/Ethnicity"
    when "f"
      ethnicity = "Not Stated"
    else
      puts "Try again."
      run_top_five
    end
    ethnicity = ethnicity.downcase
    search_top_five(ethnicity)
  end

  def search_top_five(input)
    puts "The ethnicity you chose is #{input}, I am searching..."
    death_hash = get_hash
    death_hash.top_five(input)
    play_again
  end

  def search_top_gender(input)
    death_hash = get_hash
    death_hash.top_gender(input)
    play_again
  end



  def play_again
    puts "\n"
    puts "Would you like to run another search?(Y/N)"
    answer = get_user_input
    if answer == "y"
      puts "\n"
      run_all
    elsif answer == "n"
      puts "\n"
      exit
    else
      puts "Try again - please enter 'Y' or 'N'!!!!!!"
      play_again
    end
  end



  def exit
    puts "Thanks for being interested in our open source data! Come back soon!"
  end

  def search_cause_of_death(input)
    # search_term = input.capitalize
    puts "Your search term was #{input.capitalize}, I am searching..."
    death_hash = get_hash
    death_count = death_hash.death_number (input)
    if death_count == 0
      puts "We couldn't find any deaths related to #{input}. Try again.\n"
      run_cause_of_death
    else
      death_count = death_count.to_s.reverse.gsub(/...(?=.)/,'\&,').reverse
      puts "#{death_count} people died of some disease that includes #{input}.\n"
    end
    play_again
  end

  def help
    puts "These are the options this program offers:\n
    Find the number of deaths by disease - this option searches through the database and shows the number of deaths by disease.\n
    Find Top 5 deaths by ethnicity - this option searches through the database and lists the five most occurring deaths of the ethnicity you choose.\n
    Find Top 5 deaths by gender - this option searches through the database and lists the five most occurring deaths of the gender you choose.\n"
    print "Hit return to continue:"
    get_user_input
    run_all
  end



end

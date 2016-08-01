require "csv"

class Employee
  attr_accessor :name, :phone, :address, :position, :salary, :slack, :github
  # multiple instance variables may be redundant for the purposes of initialize
  def initialize(name, phone, address, position, salary, slack, github)
    @name = name
    @phone = phone
    @address = address
    @position = position
    @salary = salary
    @position = slack
    @github = github
  end
end

class Menu
  def initialize
    @employee = []
p "initialize"
  CSV.foreach("employees.csv", { headers: true, header_converters: :symbol }) do |employee|
    name     = employee[:name]
    phone    = employee[:phone]
    address  = employee[:address]
    position = employee[:position]
    salary   = employee[:salary]
    slack    = employee[:slack]
    github   = employee[:github]
    person = Employee.new(name, phone, address, position, salary, slack, github)
    @employee << person
    end
  end

  def welcome
    puts "Welcome to the TIY Database!"
    puts "For adding personnel, press A"
    puts "For searching, press S"
    puts "For deleting, press D"
    puts "To exit, press E"
    puts "Print all, L"
  end

  def matching_employees(search_name)
    # Select from the employees
    @employee.select do |person|
      # from ruby docs on selec
      # for each person instance, return ANY part of the string that matches person name
      # OR return any matches to the person objects slack OR github
      person.name.include?(search_name) || person.slack == search_name || person.github == search_name
      end
    end

  def puts_all
    @employee.each do |match|
      puts "Match!"
      puts "#{match.name}"
      puts "#{match.phone}"
      puts "#{match.address}"
      puts "#{match.position}"
      puts "#{match.salary}"
      puts "#{match.slack}"
      puts "#{match.github}"
    end
  end

  def prompt
    loop do
      welcome
      choice = gets.chomp
        if choice == "E"
          break
        elsif choice == "A"
          puts "Enter a name"
          name = gets.chomp
          puts "What is your phone number?"
          phone = gets.chomp
          puts "What is your address"
          address = gets.chomp
          puts "What is your work position?"
          position = gets.chomp
          puts "What is your salary?"
          salary = gets.chomp
          puts "What is your Slack ID?"
          slack = gets.chomp
          puts "What is your github account?"
          github = gets.chomp
          p @employee
          person = Employee.new(name, phone, address, position, salary, slack, github)
          @employee << person
          CSV.open("employees.csv", "w") do |csv|
            csv << ["Name", "Phone", "Address", "Position", "Salary", "Slack", "Github"]
            @employee.each do |person|
              csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
            end
          end

        elsif choice == "S"
          puts "Enter name to search"
          search_name = gets.chomp!
          # local variable created to hold returned array from mathing_employees function
          matches = matching_employees(search_name)
          if matches.empty?
            p search_name "not found"
          else
            matches.each do |match|
              puts "Match!"
              puts "#{match.name}"
              puts "#{match.phone}"
              puts "#{match.address}"
              puts "#{match.position}"
              puts "#{match.salary}"
              puts "#{match.slack}"
              puts "#{match.github}"
            end
          end
        elsif choice == "D"
          # When deleting a person, prompt for the name and search for an exact match.
          # If found, delete the person, otherwise tell the user there wasn't a match.
          puts "Enter name to delete"
          delete_name = gets.chomp
          matches = matching_employees(delete_name)
          if matches.empty?
            p search_name "not found"
          else
            for person in @employee
              if person.name == delete_name
                puts "#{person.name} & all their info. has been deleted."
                @employee.delete(person)
                CSV.open("employees.csv", "w") do |csv|
                  csv << ["Name", "Phone", "Address", "Position", "Salary", "Slack", "Github"]
                  @employee.each do |person|
                    csv << [person.name, person.phone, person.address, person.position, person.salary, person.slack, person.github]
                    end
                  end
                end
              end
            end
        elsif choice == "L"
          puts_all
        end
      end
    end
  end
menu = Menu.new()
menu.prompt

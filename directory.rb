@students = []

def input_students
	puts "Enter names of students, their age & their cohort."
	puts "To exit, press Enter twice."
	puts
	puts "Enter name."
	name = STDIN.gets.chomp
	!name.empty? ? name.capitalize! : nil

	while !name.empty? do

		puts "#{name}'s age?"
		age = STDIN.gets.chomp
		age.empty? ? age = "age_unknown" : nil

		puts "And #{name}'s cohort? (First three letters of month eg. 'Jan')"
		cohort = STDIN.gets.chomp
		!cohort.empty? ? cohort.capitalize! : "cohort_unknown"
		puts

		update_students(name, age, cohort)

		if @students.count == 1
			puts "1 student registered."
		else
			puts "Now we have #{@students.count} students."
		end

		puts "Input info for another student, starting with their name, or press Enter to finish."
		puts
		name = STDIN.gets.chomp
		!name.empty? ? name.capitalize! : nil
	end
  @students
end

def update_students(name, age, cohort)
	@students << {name: name, age: age, cohort: cohort.to_sym}
end

def try_load_students
	filename = ARGV.first
	return if filename.nil?
	if File.exists?(filename)
		load_students(filename)
		puts "Loaded #{@students.count} from #{filename}."
	else
		puts "Sorry, #{filename} does not exist."
		exit
	end
end

def load_students
	puts "Load from where?"
	filename = gets.chomp
	file = File.open(filename, "r")
	file.readlines.each do |line|
		name, age, cohort = line.chomp.split(", ")
		update_students(name, age, cohort)
	end
	file.close
end

def print_menu
	puts "1. Input students info."
	puts "2. Display students info."
	puts "3. Display by cohort."
	puts "4. Save students info."
	puts "5. Load students info."
	puts "9. Exit."
end

def interactive_menu
	loop do
		print_menu
		selection = gets.chomp.to_i

		case selection
			when 1
				input_students
			when 2
				print_in_full(@students)
			when 3
				print_by_cohort(sort_by_cohort)
			when 4
				save_students
				puts "Student data saved."
			when 5
				load_students
				puts "Student data loaded."
			when 9
				exit
			else
				puts "Invalid input, please re-enter."
				puts
			end
	end
end

def print_header
	puts "The students of Villains Academy".center(100)
	puts "-------------".center(100)
end

def print_footer(names)
	if @students.count == 1
		puts "Overall, there is 1 student."
	else
		puts "Overall, there are #{names.count} students.".center(100)
	end
end

#Prints all students, alphabetically
def print_all_names(names)
	ordered_names = names.sort_by {|student| student[:name]}
	ordered_names.each.with_index(1) {|student, index| puts "#{index}. Name: #{student[:name]}, Age: #{student[:age]} (Cohort: #{student[:cohort]})".center(100)}
	puts
end

#Prints info for single student
def print_info(student)
	puts "Name: #{student[:name]}, Age: #{student[:age]} (Cohort: #{student[:cohort]})".center(100)
end

#Prints all student's info with header & footer
def print_in_full(students)
	if students.empty?
		puts "No info entered for anyone..."
	else
		print_header
		print_all_names(students)
		print_footer(students)
	end
end

def sort_by_cohort
	cohort_hash = {}
	@students.each {|student|
		if cohort_hash[student[:cohort]] == nil
			cohort_hash[student[:cohort]] = [student[:name]]
		else 
			cohort_hash[student[:cohort]] << student[:name]
		end
	}
	cohort_hash
end

def print_by_cohort(hash)
	hash.each {|key, value|
		puts "#{key}: #{value}".center(100)
	}
end

def save_students
	puts "Save to where?"
	filename = gets.chomp
	file = File.open(filename, "w")
	@students.each do |student|
		student_data = [student[:name], student[:age], student[:cohort]]
		csv_line = student_data.join(", ")
		file.puts csv_line
	end
	file.close
end

interactive_menu
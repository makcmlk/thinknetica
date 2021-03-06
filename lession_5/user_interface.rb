require_relative './railway'

class UserInterface
def self.run(railway)
  ui = UserInterface.new
  loop do
    begin
      ui.show_menu
      input = gets.chomp.to_i
      case input
      when 0
        puts '--- List of stations --------------'
        ui.list_of_stations(railway)
      when 1
        puts '--- All trains on railroad --------'
        ui.list_of_trains(railway)
      when 2
        puts '--- List of trains on station -----'
        ui.trains_on_station(railway)
      when 3
        puts '--- Move train --------------------'
        ui.move_train(railway)
      when 4
        puts '--- Add a station on railroad -----'
        ui.add_station(railway)
      when 5
        puts '--- Add a train to railroad -------'
        ui.add_train(railway)
      when 6
        puts '--- Add a route on railroad -------'
        ui.new_route(railway)
      when 7
        puts '--- Set route to train ------------'
        ui.route_to_train(railway)
      when 8
        puts '--- Change route ------------------'
        ui.change_route(railway)
      when 9
        puts '--- Add a carriage to train -------'
        ui.add_carriage(railway)
      when 10
        puts '--- Unhook a carriage from train --'
        ui.unhook_carriage(railway)
        end
      end
    end
  end

def show_menu
  puts '--- Menu -------------------------'
  puts '0 - List of stations'
  puts '1 - List of trains'
  puts '2 - List of trains by station'
  puts '3 - Move train'
  puts '4 - Add an station'
  puts '5 - Add a train'
  puts '6 - Add a route'
  puts '7 - Set a route to train'
  puts '8 - Edit route'
  puts '9 - Add a carriage to train'
  puts '10 - Unhook the carriage'
end

def list_of_stations(railroad)
  railroad.list_of_stations.each_with_index { |station, index| puts "#{index} - Station #{station.name}, #{station.list_of_trains.size} trains"}
end

def list_of_trains(railroad)
  puts '--- List of trains ---------------'
  railroad.list_of_all_trains.each { |train| puts "train  No #{train.number}, size: #{train.count_of_cars}"}
end

def trains_on_station(railroad)
  railroad.list_of_stations.each_with_index { |station, index| puts "#{index} - Station #{station.name}, #{station.list_of_trains.size} trains"}
  puts 'Enter number of station: '
  input = gets.chomp.to_i
  list = railroad.list_of_trains(input)
  if list.is_a?(Array)
    puts 'Numbers of trains on this station:'
    list.each { |train| puts "train  No #{train.number}" }
  else
    puts 'Wrong number of station'
  end
end

def add_station(railroad)
  puts 'Input the title of station'
  station_name = gets.chomp
  railroad.new_station(station_name)
  puts "Station #{station_name} is created."
  railroad.list_of_stations
end

def add_train(railroad)
  puts 'Select type of new train:'
  puts '0 - Passenger train'
  puts '1 - Cargo train'
  puts 'any other - cancel'
  input = gets.chomp.to_i
  case input
  when 0
    number = railroad.new_p_train
    puts "New train No #{number} is created"
  when 1
    number = railroad.new_c_train
    puts "New train No #{number} is created"
  else
    puts 'Canceled'
  end
end

def add_carriage(railroad)
  list_of_trains(railroad)
  puts 'Enter a number of train to add a carriage'
  input = gets.chomp.to_i
  railroad.add_car_to(input)
end

def unhook_carriage(railroad)
  list_of_trains(railroad)
  puts 'Enter a number of train to add a carriage'
  input = gets.chomp.to_i
  railroad.delete_car_from(input)
end

def new_route(railroad)
  railroad.list_of_stations.each_with_index { |station, index| puts "#{index} - Station #{station.name}, #{station.list_of_trains.size} trains"}
  puts 'Enter a number of the start station:'
  start_number = gets.chomp.to_i
  puts 'Enter a number of the finish station:'
  end_number = gets.chomp.to_i
  list_of_new_route = railroad.new_route(start_number, end_number)
  puts "New route: #{list_of_new_route} is created"
end

def route_to_train(railroad)
  if railroad.list_of_all_trains.empty?
    puts 'List of trains is empty!'
  else
    puts 'All trains:'
    railroad.list_of_all_trains.each { |train| puts "train  No #{train.number}, size: #{train.count_of_cars}"}
    puts 'Enter a number of train:'
    number_of_train = gets.chomp.to_i
    puts 'All routes:'
    railroad.routes.each_with_index { |route, index| puts "#{index}:  #{route.list}" }
    puts 'Enter a number of route:'
    number_of_route = gets.chomp.to_i
    new_route_list = railroad.set_route(number_of_train, number_of_route)
    puts "Route #{new_route_list}"
  end
end

def add_station_in_route(railroad, route_number)
  list_of_stations(railroad)
  puts 'Enter number of station to add into route:'
  station_number = gets.chomp.to_i
  puts railroad.route(route_number)
  puts 'Enter number of position:'
  position_number = gets.chomp.to_i
  new_route = railroad.add_in_route(route_number, station_number, position_number)
  puts "Route changes: #{new_route}"
end

def delete_station_from_route(railroad, route_number)
  puts railroad.route(route_number)
  puts 'Enter number of station:'
  station_number = gets.chomp.to_i
  new_route = railroad.delete_from_route(route_number, station_number)
  puts "Route changes: #{new_route}"

end

def change_route(railroad)
  railroad.routes.each_with_index { |route, index| puts "#{index}:  #{route.list}" }
  puts 'Enter a number of route:'
  number_of_route = gets.chomp.to_i
  puts railroad.route(number_of_route)
  puts 'What to do with route: 0 - add station in route, 1 - delete station, 2 - cancel'
  action = gets.chomp.to_i
  case action
  when 0
    add_station_in_route(railroad, number_of_route)
  when 1
    delete_station_from_route(railroad, number_of_route)
  when 2
    puts 'Canceled'
  end
end

def move_train(railroad)
  railroad.list_of_all_trains.each { |train| puts "train  No #{train.number}, size: #{train.count_of_cars}"}
  puts 'Enter a number of train to move:'
  number_of_train = gets.chomp.to_i
  if !railroad.current_station(number_of_train).nil?
    puts "Train number #{number_of_train}, on station #{railroad.current_station(number_of_train).name}"
    puts 'Select action: 0 - next station, 1 - previous station, 2 - cancel'
    action = gets.chomp.to_i
    case action
    when 0
      railroad.go_next(number_of_train)
    when 1
      railroad.go_prev(number_of_train)
    when 2
      puts 'Canceled'
    end
  end
end

end

class Route
  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(station, order)
    if order <= @stations.size
      @stations.insert(order, station)
      puts "#{station.name} is in the route"
    else
      puts 'Station is not in the route'
    end
  end

  def delete_station(station)
    @stations.delete_if { |x| x == station }
  end

private
# не используем этот метод
  def list
    puts 'Stations in this route:'
    @stations.each { |station| puts station.name }
  end

  def station(number)
    @stations[number]
  end

  def size
    @stations.size
  end
end

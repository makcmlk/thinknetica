class Route
  def initialize(from, to)
    @stations = [from, to]
    validate!
  end

  def valid?
    validate!
  rescue
    false
  end

  def add_station(station, order)
    if order <= @stations.size
      @stations.insert(order, station)
    else
      nil
    end
  end

  def delete_station(station)
    @stations.delete_if { |x| x == station }
  end

  def list
    list = ''
    @stations.each_with_index { |station, index| list+="[#{index}] #{station.name}, " }
    list
  end

  def station(number)
    return @stations[number] unless @stations[number].nil?
  end

  def size
    @stations.size
  end

  protected

  def validate!
    raise 'No or invalid start station' if @stations[0].is_a?(Station)
    raise 'No or invalid finish station' if @stations[1].is_a?(Station)
  end

end

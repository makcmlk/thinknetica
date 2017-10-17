class Station
  attr_accessor :name

  @@stations = []

  class << self
    def all
      @stations
    end
  end

  def initialize(name)
    @name = names
    @trains = []
    @@stations.push(station)
  end

  def valid?
    validate!
  rescue
    false
  end

  def get_train(train)
    if train.is_a?(Train)
      @trains.push(train)
    end
  end

  def send_train(train)
    if train.is_a?(Train)
      @trains.delete(train)
    end
  end

  def list_of_trains
    @trains
  end

  protected

  def validate!
    raise "Name of station can't be empty" if name.nil?
    raise 'Name of station should be at least 3 symbols' if name.length < 3
    true
  end

  private

  def list_of_trains_by(type)
    trains_of_type = []
    @trains.each do |train|
      trains_of_type.push(train) if train.type == type
    end
    trains_of_type
  end
end

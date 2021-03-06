require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative './accessor'
require_relative './validation'

class Train
  include Manufacturer
  include InstanceCounter
  include Validation
  extend Accessor
  attr_accessor :number
  attr_accessor_with_history :station_number

  NUMBER_FORMAT = /[\w]{3}(\-)?[\w]{2}/

  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  @@trains = {}

  class << self
    def find(number)
      @@trains[number]
    end
  end

  def initialize(name)
    @number = name
    validate!
    @cars = []
    @count_of_cars = count_of_cars
    @speed = 0
    @@trains[@number] = self
    register_instance
  end

  def each_car
    @cars.each_with_index { |car, index| yield(car, index) }
  end

  def valid?
    validate!
  rescue
    false
  end

  def route(new_route)
    @route = new_route
    @station_number = 0
  end

  def move_next
    return if @route.nil?
    return unless @station_number < @route.size
    @station_number += 1
    @route.station(@station_number)
  end

  def move_prev
    return if @route.nil?
    return unless @station_number >= 1
    @station_number -= 1
    @route.station(@station_number)
  end

  def count_of_cars
    @cars.size
  end

  def delete_car
    return @cars.delete(@cars.last) unless @cars.empty?
  end

  def current_station
    return @route.station(@station_number) unless @route.nil?
  end

  def next_station
    @route.station(@station_number + 1) if !@route.nil? && @station_number < @route.size - 1
  end

  def prev_station
    @route.station(@station_number - 1) if !@route.nil? && @station_number > 0
  end

  def add_car(new_car)
    @cars.push(new_car) if valid_car?(new_car)
  end

  def occupy_place(volume)
    @cars.each { |car| break if car.occupy(volume) } unless @cars.empty?
  end

  protected

  def valid_car?(new_car)
  end


  #def validate!
  #  raise 'Number of train cant be empty' if number.nil?
  #  raise 'Number of train should be at least 5 symbols' if number. < 5
#    raise "Number #{number} has invalid format" if number !~ NUMBER_FORMAT
#   end

  private

  def up_speed
    @speed += 60
  end

  def stop
    @speed = 0
  end
end

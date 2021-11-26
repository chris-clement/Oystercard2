# require 'oystercard'

class Journey
  attr_accessor :entry_station, :journey_history, :exit_station

  PENALTY_FARE = 10
  MINIMUM_FARE = 5

  def initialize(station = nil)
    @entry_station = station
    @exit_station = nil
    @journey_history = []
  end

  def in_journey?
    @entry_station.nil? ? false : true
  end

  def fare
    complete? ? MINIMUM_FARE : PENALTY_FARE
  end

  def complete?
    !(@entry_station.nil? || @exit_station.nil?)
  end
end

require_relative 'journey'
class Oystercard
  attr_reader :balance, :journey_history, :exit_station, :entry_station

  TOP_UP_LIMIT = 90
  MINIMUM_BALANCE = 1
  FARE = 6

  def initialize(journey = Journey.new)
    @balance = 0
    @journey = journey
    # @journey_history = []
  end

  def top_up(amount)
    raise "top-up limit of £#{TOP_UP_LIMIT} reached" if limit_exceeded?(amount)

    @balance += amount
  end

  def touch_in(station)
    raise 'Insufficient balance to touch in' if insufficient_funds?

    @journey.entry_station = station
    @journey.journey_history << { entry_station: station }
  end

  def touch_out(station)
    @journey.exit_station = station
    deduct
    @journey.entry_station = nil
  end

  private

  def limit_exceeded?(amount)
    @balance + amount > TOP_UP_LIMIT
  end

  def insufficient_funds?
    @balance < MINIMUM_BALANCE
  end

  def deduct
    @balance -= @journey.fare
  end

  def current_journey_index
    @journey.journey_history.length - 1
  end
end

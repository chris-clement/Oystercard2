require 'oystercard'

describe Oystercard do
  let (:input_station) { double(:input_station) }

  it 'card should have a balance' do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'allows us to top up the card by a given value' do
      expect { subject.top_up 10 }.to change { subject.balance }.by 10
    end

    it 'should raise an error if you top_up beyond the limit' do
      expect { subject.top_up(Oystercard::TOP_UP_LIMIT + 1) }.to raise_error "top-up limit of £#{Oystercard::TOP_UP_LIMIT} reached"
    end
  end

  describe '#touch_in' do
    it 'should result in_journey to return true if balance is more than or equal to £1 (minimum balance)' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(input_station)
      expect(subject.in_journey?).to be_truthy
    end

    it 'card should not be able to touch_in if balance is less than £1 (minimum balance)' do
      expect { subject.touch_in(input_station) }.to raise_error 'Insufficient balance to touch in'
    end

    it 'returns the entry station when we call the method entry_station' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(input_station)
      expect(subject.entry_station).to eq(input_station)
    end
  end

  describe '#touch_out' do
    it 'should result in_journey to return false when we touch_out' do
      subject.touch_out
      expect(subject.in_journey?).to be_falsey
    end

    it 'balance should reduce by fare amount' do
      expect { subject.touch_out }.to change { subject.balance }.by(-Oystercard::FARE)
    end

    it 'should forget the entry station' do
      subject.top_up(Oystercard::MINIMUM_BALANCE)
      subject.touch_in(input_station)
      subject.touch_out
      expect(subject.entry_station).to be_nil
    end
  end
end

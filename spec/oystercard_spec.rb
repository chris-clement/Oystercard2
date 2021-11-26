require 'oystercard'

describe Oystercard do
  let(:start_station) { double(:start_station) }
  let(:end_station) { double(:end_station) }

  before(:each) do |test|
    unless test.metadata[:skip_top_up_touch_in]
      subject.top_up(Oystercard::FARE)
      subject.touch_in(start_station)
    end
  end

  it 'has a balance of 0 when Oystercard is created', :skip_top_up_touch_in do
    expect(subject.balance).to eq 0
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'increases balance on card by a given value' do
      expect { subject.top_up 10 }.to change { subject.balance }.by 10
    end

    it 'raises an error if you top_up beyond the limit', :skip_top_up_touch_in do
      expect { subject.top_up(Oystercard::TOP_UP_LIMIT + 1) }.to raise_error "top-up limit of £#{Oystercard::TOP_UP_LIMIT} reached"
    end
  end

  describe '#touch_in' do
    it 'raises error if balance is below minimum', :skip_top_up_touch_in do
      expect { subject.touch_in(start_station) }.to raise_error 'Insufficient balance to touch in'
    end
  end

  describe '#touch_out' do
    before(:each) do |test|
      subject.touch_out(end_station) unless test.metadata[:skip_touch_out]
    end

    it 'sets the entry station to nil' do
      expect(subject.entry_station).to be_nil
    end
  end
end

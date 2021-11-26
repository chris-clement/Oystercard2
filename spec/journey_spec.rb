require 'journey'

describe Journey do
  let(:start_station) { double(:start_station) }
  let(:end_station) { double(:end_station) }
  let(:card) { double(:card) }

  before(:each) do |test|
    unless test.metadata[:skip_allow_touch_in]
      allow(card).to receive(:touch_in) { subject.entry_station = start_station }
      # card.touch_in(start_station)
      allow(card).to receive(:touch_out) { subject.exit_station = end_station }
    end
  end

  describe '#in_journey?' do
    context 'journey initialized with a station' do
      it 'returns true' do
        journey = Journey.new(start_station)
        expect(journey.in_journey?).to be_truthy
      end
    end

    context 'journey initialized without a station' do
      it 'returns false' do
        expect(subject.in_journey?).to be_falsey
      end
    end

    context 'when we touch out' do
      it 'returns false' do
        journey = Journey.new(start_station)
        allow(card).to receive(:touch_out) { journey.entry_station = nil }
        card.touch_out(end_station)
        expect(journey.in_journey?).to be_falsey
      end
    end

    context 'when we touch in' do
      it 'returns true' do
        card.touch_in(start_station)
        expect(subject.in_journey?).to be_truthy
      end
    end
  end

  describe '#journey_history' do
    context 'no journeys have been made' do
      it 'returns a empty array' do
        expect(subject.journey_history).to be_empty
      end
    end

    context '1 journey has been made' do
      xit 'returns a entry and exit station' do
        card.touch_in(start_station)
        card.touch_out(end_station)
        expect(subject.journey_history[0]).to include(entry_station: start_station, exit_station: end_station)
      end
    end

    context 'multiple journeys have been made' do
      xit 'returns history of all journeys' do
        2.times do
          card.touch_in(start_station)
          card.touch_out(end_station)
        end
        expect(subject.journey_history.length).to eq 2
      end
    end
  end

  describe '#fare' do
    before do
      card.touch_in(start_station)
    end

    context 'complete journey' do
      it 'charges the minimum fare' do
        card.touch_out(end_station)
        expect(subject.fare).to eq Journey::MINIMUM_FARE
      end
    end

    context 'incomplete journey' do
      it 'charges penalty fare' do
        expect(subject.fare).to eq Journey::PENALTY_FARE
      end
    end
  end
end

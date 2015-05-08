require 'spec_helper'

module GreenButton
  describe IntervalBlock do
    subject { example_usage_point.meter_readings.first.interval_blocks.first }

    it { is_expected.to be_a IntervalBlock }

    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:duration) { is_expected.to eq 2678400 }
    its(:end_time) { is_expected.to eq Time.at(1293868800+2678400).utc }
    its(:href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01/IntervalBlock/0173' }
    its(:id) { is_expected.to eq 'urn:uuid:EE0EC179-2726-43B1-BFE2-40ACC6A8901B' }
    its(:parent_href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01/IntervalBlock' }
    its(:start_time) { is_expected.to eq Time.at(1293868800).utc }
    its(:title) { is_expected.to eq '' }

    it 'calculates correct total' do
      expect(subject.total).to eq 291018.0
    end

    it 'calculates correct average' do
      expect(subject.average_interval_value).to eq (291018.0 / 362.0)
    end

    it 'calculates correct sum over time interval' do
      date1 = Time.at(1293915600).utc
      date2 = Time.at(1293922800).utc
      expect(subject.sum(date1, date2)).to eq (852 + 798)
    end

    it 'returns correct value at given time' do
      expect(subject.value_at_time(Time.at(1293919600).utc)).to eq 798
    end
  end
end

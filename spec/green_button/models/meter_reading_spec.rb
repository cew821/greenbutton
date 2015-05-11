require 'spec_helper'

module GreenButton
  describe MeterReading do
    subject{ example_usage_point.meter_readings.first }

    it { is_expected.to be_a(MeterReading) }

    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01' }
    its(:id) { is_expected.to eq 'urn:uuid:9BCDAB06-6690-46A3-9253-A451AF4077D8' }
    its(:parent_href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01/MeterReading' }
    its(:title) { is_expected.to eq 'Hourly Electricity Consumption' }

    it 'has one ReadingType' do
      expect(subject.reading_type).to be_a(ReadingType)
    end

    it 'has one IntervalBlock' do
      expect(subject.interval_blocks.length).to eq(1)
    end
  end
end

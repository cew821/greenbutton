require 'spec_helper'

module GreenButton
  describe IntervalReading do
    let(:interval_block) { example_usage_point.meter_readings.first.interval_blocks.first }

    subject { interval_block.reading_at_time(Time.at(1293919600).utc) }

    it { is_expected.to be_a IntervalReading }

    its(:duration) { is_expected.to eq 3600 }
    its(:end_time) { is_expected.to eq Time.at(1293919200+3600).utc }
    its(:start_time) { is_expected.to eq Time.at(1293919200).utc }
    its(:value) { is_expected.to eq 798 }
  end
end

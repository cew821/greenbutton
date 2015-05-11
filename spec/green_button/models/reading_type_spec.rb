require 'spec_helper'

module GreenButton
  describe ReadingType do
    subject{ example_usage_point.meter_readings.first.reading_type }

    its(:accumulation_behaviour) { is_expected.to eq 4 }
    its(:commodity) { is_expected.to eq 1 }
    its(:currency) { is_expected.to eq 840 }
    its(:data_qualifier) { is_expected.to eq 12 }
    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:flow_direction) { is_expected.to eq 1 }
    its(:href) { is_expected.to eq 'ReadingType/07' }
    its(:id) { is_expected.to eq 'urn:uuid:BEB04FF1-6294-4916-95AC-5597070C95D4' }
    its(:kind) { is_expected.to eq 12 }
    its(:parent_href) { is_expected.to eq 'ReadingType' }
    its(:phase) { is_expected.to eq 769 }
    its(:power_of_ten_multiplier) { is_expected.to eq 0 }
    its(:time_attribute) { is_expected.to eq 0 }
    its(:title) { is_expected.to eq 'Energy Delivered (kWh)' }
    its(:uom) { is_expected.to eq 72 }
  end
end

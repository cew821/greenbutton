require 'spec_helper'

module GreenButton
  describe ElectricPowerUsageSummary do
    subject{ example_usage_point.electric_power_usage_summaries.first }

    it { is_expected.to be_a ElectricPowerUsageSummary }

    its(:bill_duration) { is_expected.to eq 2592000 }
    its(:bill_start) { is_expected.to eq Time.at(1320130800).utc }
    its(:current_power_ten) { is_expected.to eq 0 }
    its(:current_timestamp) { is_expected.to eq Time.at(1325401200).utc }
    its(:current_uom) { is_expected.to eq 72 }
    its(:current_value) { is_expected.to eq 610314 }
    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:href) { is_expected.to eq 'RetailCustomer/9b6c7063/ElectricPowerUsageSummary/01' }
    its(:id) { is_expected.to eq 'urn:uuid:429EAE17-A8C7-4E7F-B101-D66173B2166C' }
    its(:last_power_ten) { is_expected.to eq nil }
    its(:last_uom) { is_expected.to eq nil }
    its(:last_value) { is_expected.to eq nil }
    its(:parent_href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01/ElectricPowerUsageSummary' }
    its(:title) { is_expected.to eq 'Usage Summary' }
  end
end

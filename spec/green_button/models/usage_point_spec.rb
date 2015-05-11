require 'spec_helper'

module GreenButton
  describe UsagePoint do
    subject { example_usage_point }

    its(:customer_id) { is_expected.to eq '9b6c7063' }
    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:electric_power_quality_summaries) { is_expected.to be_empty }
    its(:electric_power_usage_summaries) { is_expected.to_not be_empty }
    its(:href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint/01' }
    its(:id) { is_expected.to eq 'urn:uuid:4217A3D3-60E0-46CD-A5AF-2A2D091F397E' }
    its(:local_time_parameters) { is_expected.to be_a LocalTimeParameters }
    its(:meter_readings) { is_expected.to_not be_empty }
    its(:parent_href) { is_expected.to eq 'RetailCustomer/9b6c7063/UsagePoint' }
    its(:service_kind) { is_expected.to eq :electricity }
    its(:title) { is_expected.to eq 'Coastal Single Family' }

    it 'knows its related hrefs' do
      expect(subject.related_hrefs).to include 'RetailCustomer/9b6c7063/UsagePoint/01/MeterReading'
      expect(subject.related_hrefs).to include 'RetailCustomer/9b6c7063/UsagePoint/01/ElectricPowerUsageSummary'
      expect(subject.related_hrefs).to include 'LocalTimeParameters/01'
    end
  end
end

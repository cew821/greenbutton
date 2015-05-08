require 'spec_helper'

module GreenButton
  describe LocalTimeParameters do
    subject { example_usage_point.local_time_parameters }

    its(:date_published) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:date_updated) { is_expected.to eq DateTime.parse('2012-10-24T00:00:00Z').to_time.utc }
    its(:dst_end_rule) { is_expected.to eq 'B40E2000' }
    its(:dst_offset) { is_expected.to eq 3600 }
    its(:dst_start_rule) { is_expected.to eq '360E2000' }
    its(:href) { is_expected.to eq 'LocalTimeParameters/01' }
    its(:id) { is_expected.to eq 'urn:uuid:FE317A0A-F7F5-4307-B158-28A34276E862' }
    its(:parent_href) { is_expected.to eq 'LocalTimeParameters' }
    its(:title) { is_expected.to eq 'DST For North America' }
    its(:tz_offset) { is_expected.to eq -28800 }
  end
end

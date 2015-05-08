require 'spec_helper'

module GreenButton
  describe Helpers do
    describe '.translate' do
      it 'correctly parses :ServiceKind' do
        expect(Helpers.translate(:ServiceKind, '7')).to eq(:rates)
      end

      it 'fails gracefully if it cant find the :serviceKind' do
        expect(Helpers.translate(:ServiceKind, '100')).to eq('100')
      end

      it 'correctly parses :integer' do
        expect(Helpers.translate(:integer, '2343')).to eq(2343)
      end

      it 'correctly parses :datetime' do
        expect(Helpers.translate(:datetime, '2012-10-24T00:00:00Z')).to eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc)
      end

      it 'correctly parses :unixtime' do
        expect(Helpers.translate(:unix_time, '1293868800')).to eq(Time.at(1293868800).utc)
      end
    end

    describe :pluralize do
      it 'pluralizes words correctly' do
        expect(Helpers.pluralize('crock')).to eq('crocks')
        expect(Helpers.pluralize('utility')).to eq('utilities')
      end
    end

    describe :underscored do
      it 'underscores camelcased words correctly' do
        expect(Helpers.underscore('yourAvgUtility')).to eq('your_avg_utility')
        expect(Helpers.underscore('YourAvgUtility')).to eq('your_avg_utility')
      end
    end
  end
end

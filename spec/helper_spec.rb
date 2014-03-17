require 'spec_helper'
require './lib/helpers.rb'

describe :translate do
  it "correctly parses :ServiceKind" do
    expect(Helper.translate(:ServiceKind, '7')).to eq(:rates)
  end

  it "fails gracefully if it can't find the :serviceKind" do
    expect(Helper.translate(:ServiceKind, '100')).to eq('100')
  end

  it "correctly parses :integer" do
    expect(Helper.translate(:integer, '2343')).to eq(2343)
  end

  it "correctly parses :datetime" do
    expect(Helper.translate(:datetime, '2012-10-24T00:00:00Z')).to eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc)
  end

  it "correctly parses :unixtime" do
    expect(Helper.translate(:unix_time, '1293868800')).to eq(Time.at(1293868800).utc)
  end
end

describe :pluralize do
  it "pluralizes words correctly" do
    expect(Helper.pluralize('crock')).to eq('crocks')
    expect(Helper.pluralize('utility')).to eq('utilities')
  end
end

describe :underscored do
  it "underscores camelcased words correctly" do
    expect(Helper.underscore('yourAvgUtility')).to eq('your_avg_utility')
    expect(Helper.underscore('YourAvgUtility')).to eq('your_avg_utility')
  end
end

describe Helper::Rule do
  it "should have a attribute name" do
    rule = Helper::Rule.new(:attr_name,"xpath",:DateTime)
    expect(rule.attr_name).to eq :attr_name
    expect(rule.xpath).to eq "xpath"
    expect(rule.type).to eq :DateTime
  end
end
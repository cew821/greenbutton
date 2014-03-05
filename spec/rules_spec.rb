require 'spec_helper'

require_relative '../lib/greenbutton'

describe GreenButton::Rule do
	it "should have a attribute name" do
		rule = GreenButton::Rule.new(:attr_name,"xpath",:DateTime)
		expect(rule.attr_name).to eq :attr_name
		expect(rule.xpath).to eq "xpath"
		expect(rule.type).to eq :DateTime
	end
end
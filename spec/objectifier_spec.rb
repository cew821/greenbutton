require 'spec_helper'

require_relative '../lib/greenbutton'

describe GreenButton::Objectifier, '.parse' do
	it "accepts xml, rule and object, and creates the right object" do
		object = GreenButton::UsagePoint.new
		rule = GreenButton::Rule.new(:service_kind, "ServiceCategory/kind", :ServiceKind)
		xml = load_sample_xml.xpath('//UsagePoint').first
		GreenButton::Objectifier.parse(xml, rule, object)
		expect(object.service_kind).to eq :electricity
	end
end

describe GreenButton::Objectifier, ".type_translator" do
	it "parses service kinds" do
		translation = GreenButton::Objectifier.type_translator(:ServiceKind, "0")
		expect(translation).to eq :electricity
	end
end
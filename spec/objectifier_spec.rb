require 'spec_helper'

require_relative '../lib/parser'

describe GreenButton::Objectifier, ".type_translator" do
	it "parses service kinds" do
		translation = GreenButton::Objectifier.type_translator(:ServiceKind, "0")
		expect(translation).to eq :electricity
	end
end
require 'spec_helper'

require_relative '../lib/parser'

describe GreenButton::Parser do
	it "should initialize" do
		parser = GreenButton::Parser.new("doc")
		expect(parser).to be_true
	end

	it "should store the xml doc on initialization" do
		doc = load_sample_xml
		parser = GreenButton::Parser.new(doc)
		expect(parser.doc).to eq doc
	end

	it "should parse a file into a GreenButton::Data object" do
		doc = load_sample_xml
		parser = GreenButton::Parser.new(doc)
		expect(parser.parse_greenbutton_xml.class).to eq GreenButton::Data
	end

	describe GreenButton::Parser, '#parse_usage_points' do
		it "should have at least one usage_point" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.class).to eq GreenButton::UsagePoint
			expect(parsed_data.usage_points.count).to be > 0
		end

		it "knows its service category" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.service_kind).to eq "0"
		end

		it "knows its own href" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.self_href).to eq "RetailCustomer/9b6c7063/UsagePoint/01"
		end
	end
end

describe GreenButton::Loader do
	it "should initialize" do
		loader = GreenButton::Loader.new
		expect(loader).to be_true
	end

	it "should be able to load an XML file" do
		xml = load_sample_xml
		expect(xml).to be_true
	end
end

def new_parser_with_data
	doc = load_sample_xml
	parser = GreenButton::Parser.new(doc)
end

def load_and_parse_greenbutton
	parser = new_parser_with_data
	parser.parse_greenbutton_xml
end

def load_sample_xml
	file_path = "data/Coastal_Single_Family_Jan_1_2011_to_Jan_1_2012.xml"	
	loader = GreenButton::Loader.new
	loader.load_xml_from_file(file_path)
end
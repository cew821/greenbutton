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
			expect(parsed_data.usage_points.first.service_kind).to eq :electricity
		end

		it "knows its ID" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.id).to eq "urn:uuid:4217A3D3-60E0-46CD-A5AF-2A2D091F397E"
		end

		it "knows its own href" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.self_href).to eq "RetailCustomer/9b6c7063/UsagePoint/01"
		end

		it "knows its related hrefs" do
			parsed_data = load_and_parse_greenbutton
			expect(parsed_data.usage_points.first.related_hrefs.count).to eq 3
		end
	end

	describe GreenButton::Parser, '#parse_related_hrefs' do
		it "parses local time parameters" do
			parser = new_parser_with_data
			xml = parser.doc
			point = parser.parsed_usage_point(xml.xpath('//UsagePoint').first)
			parser.parse_related(xml, point)
			expect(point.local_time_parameters.dst_end_rule).to eq "B40E2000"
			expect(point.local_time_parameters.dst_offset).to eq "3600"
			expect(point.local_time_parameters.dst_start_rule).to eq "360E2000"
			expect(point.local_time_parameters.tz_offset).to eq "-28800"
		end

		it "parses the electric power usage summary" do
			parser = new_parser_with_data
			xml = parser.doc
			point = parser.parsed_usage_point(xml.xpath('//UsagePoint').first)
			parser.parse_related(xml, point)
			expect(point.electric_power_usage_summary.billing_period.start).to eq "2011-11-01z07:00:00"
		end

		# it "parses meter readings within interval blocks" do 
		# 	parser = new_parser_with_data
		# 	xml = parser.doc
		# 	point = parser.parsed_usage_point(xml.xpath('//UsagePoint').first)
		# 	parser.parse_related(xml, point)
		# 	expect(point.meter_readings.first.interval_blocks.first.interval.dst_end_rule).to eq "B40E2000"
		# 	expect(point.local_time_parameters.dst_offset).to eq "3600"
		# 	expect(point.local_time_parameters.dst_start_rule).to eq "360E2000"
		# 	expect(point.local_time_parameters.tz_offset).to eq "-28800"
		# end
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

module GreenButton
	require 'nokogiri'
	require 'open-uri'

	require_relative 'greenbutton/objectifier.rb'

	class Parser
		attr_accessor :doc

		def initialize(doc)
			@doc = doc
		end

		def parse_greenbutton_xml
			parsed_data = Data.new
			parsed_data.usage_points = parsed_usage_points
			parsed_data
		end

		def parsed_usage_points
			usage_points = []
			doc.xpath('//UsagePoint').each do |usage_point|
				usage_points << parsed_usage_point(usage_point)
			end
			usage_points
		end

		def parsed_usage_point(usage_point_xml)
			point = UsagePoint.new
			rules = [
				Rule.new(:service_kind, "ServiceCategory/kind", :ServiceKind),
				Rule.new(:self_href, "../../link[@rel='self']/@href", :string),
				Rule.new(:id, "../../id", :string)]
			Objectifier.parse_group(usage_point_xml, rules, point)
			parse_related(usage_point_xml, point)
			point
		end

		def parse_related(xml, point)
			related_hrefs = []
			xml.xpath("../../link[@rel='related']/@href").each do |rel|
				related_hrefs << rel.text
				if !xml.xpath("//link[@rel='self' and @href='#{rel.text}']/..").empty?
					related_entry = xml.xpath("//link[@rel='self' and @href='#{rel.text}']/..")
				elsif !xml.xpath("//link[@rel='up' and @href='#{rel.text}']/..").empty?
					related_entry = xml.xpath("//link[@rel='up' and @href='#{rel.text}']/..")
				end
				parse_entry(related_entry, point)
			end
			point.related_hrefs = related_hrefs
			puts related_hrefs
		end

		def parse_entry(xml, point)
			parse_local_time_parameters(xml.xpath('content/LocalTimeParameters'), point)
			parse_electric_power_usage_summary(xml.xpath('content/ElectricPowerUsageSummary'),point)
			parse_meter_reading(xml.xpath('content/MeterReading'), point)
		end

		def parse_meter_reading(xml, point)
			return if xml.empty?
			point.meter_readings = []
			point.reading_type
		end

		def parse_electric_power_usage_summary(xml, point)
			return if xml.empty?
			point.electric_power_usage_summary = ElectricPowerUsageSummary.new
			rules = [
				Rule.new(:power_of_ten_multiplier, 'currentBillingPeriodOverAllConsumption/powerOfTenMultiplier', :integer),
				Rule.new(:billing_period_start, 'billingPeriod/start', :time)
			]
			Objectifier.parse_group(xml, rules, point.electric_power_usage_summary)
		end

		def parse_local_time_parameters(xml, point)
			return if xml.empty?
			point.local_time_parameters = LocalTimeParameters.new
			rules = [ 
				Rule.new(:dst_end_rule, "dstEndRule", :string),
				Rule.new(:dst_offset, "dstOffset", :integer),
				Rule.new(:dst_start_rule, "dstStartRule", :string),
				Rule.new(:tz_offset, "tzOffset", :integer)
			]
			Objectifier.parse_group(xml, rules, point.local_time_parameters)
		end

		def generic_parser(xml, rules, append_to)
			rules.each do |rule|
				text = xml.xpath(rule.xpath).text
				append_to.send(rule.attr_name.to_s+"=", text)
			end
		end
	end

	class Data
		attr_accessor :usage_points
	end

	class UsagePoint
		attr_accessor :service_kind, :self_href, :related_hrefs, :local_time_parameters, :id, :electric_power_usage_summary, :meter_readings, :reading_type
	end

	class ReadingType
		attr_accessor :accumulation_behavior, :commodity, :currency, :data_qualifier, :flow_direction, :interval_length, :kind, :phase, :power_of_ten_multiplier, :time_attribute, :uom
	end

	class ElectricPowerUsageSummary
		attr_accessor :billing_period_start, :billing_period_duration, :power_of_ten_multiplier
	end

	class LocalTimeParameters
		attr_accessor :dst_end_rule, :dst_offset, :dst_start_rule, :tz_offset
	end

	class Rule
		attr_accessor :attr_name, :xpath, :type

		def initialize(attr_name, xpath, type)
			@attr_name = attr_name
			@xpath = xpath
			@type = type
		end
	end

	class Loader
		attr_accessor :xml_file

		# could also load this from the data custodian:feed
		# url = "http://services.greenbuttondata.org:80/DataCustodian/espi/1_1/resource/RetailCustomer/1/DownloadMyData"

		def load_xml_from_web(url)
			@xml_file = Nokogiri.XML(open(url))
			@xml_file.remove_namespaces!
		end

		def load_xml_from_file(path)
			@xml_file = Nokogiri.XML(File.open(path, 'rb'))
			@xml_file.remove_namespaces!
		end
	end
end



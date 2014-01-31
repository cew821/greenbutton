module GreenButton
	require 'nokogiri'
	require 'open-uri'

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
				parsed = parsed_usage_point(usage_point)
				usage_points << UsagePoint.new(parsed)
			end
			usage_points
		end

		def parsed_usage_point(usage_point)
			{ service_kind: usage_point.xpath('ServiceCategory/kind').text,
				self_href: usage_point.xpath("../../link[@rel='self']/@href").text,
			}
		end
	end



	class Data
		attr_accessor :usage_points
	end

	class UsagePoint
		attr_reader :service_kind, :self_href

		def initialize(parsed_usage_point)
			@service_kind = parsed_usage_point[:service_kind]
			@self_href = parsed_usage_point[:self_href]
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



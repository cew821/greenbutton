module GreenButton
	require 'nokogiri'
	require_relative 'greenbutton/gb_classes.rb'
	
	UsagePoint = GreenButtonClasses::UsagePoint
	  
  # could also load this from the data custodian:feed
  # url = "http://services.greenbuttondata.org:80/DataCustodian/espi/1_1/resource/RetailCustomer/1/DownloadMyData"

  def self.load_xml_from_web(url)
    xml_file = Nokogiri.XML(open(url))
    xml_file.remove_namespaces!
    Parser.new(xml_file)
  end

  def self.load_xml_from_file(path)
    xml_file = Nokogiri.XML(File.open(path, 'rb'))
    xml_file.remove_namespaces!
    Parser.new(xml_file)
  end
	  

	class Parser
		attr_accessor :doc, :usage_points

		def initialize(doc)
			self.doc = doc
			self.usage_points = []
			doc.xpath('//UsagePoint/../..').each do |usage_point_entry|
        @usage_points << UsagePoint.new(nil, usage_point_entry.remove, self)
      end
		end
		
		def filter_usage_points(params)
		  # customer_id, service_kind, title, id, href
		  filtered = []
		  self.usage_points.each do |usage_point|
		    include = true
		    params.each_pair do |key, value|
		      if usage_point.send(key) != value
		        include = false
		        break
		      end
		    end
		    filtered << usage_point if include
		  end
		  filtered
		end
		
		def get_unique(attr)
		  #customer_id, service_kind, title
		  unique = []
      self.usage_points.each do |usage_point|
        val = usage_point.send(attr)
        if !unique.include?(val)
          unique << val
        end
      end
      unique
		end
		
	end
end



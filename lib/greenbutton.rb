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

  def self.load_xml_from_string(string)
    xml_file = Nokogiri::XML.parse(string)
    xml_file.remove_namespaces!
    Parser.new(xml_file)
  end

	class Parser
		attr_accessor :doc, :usage_points

		def initialize(doc)
      self.doc = doc
      self.usage_points = []
      doc.xpath('//UsagePoint/../..').each do |usage_point_entry|
        up = UsagePoint.new(nil, usage_point_entry.remove, self)
        if filter_usage_points(href: up.href).length == 0
          @usage_points << up
        end
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
		
    def start_time(params=nil)
      if params
        ups = filtered_usage_points(params)
      else
        ups = self.usage_points
      end
      start_time = Time.now
      ups.each do |up|
        start_time = [start_time, up.start_time].min
      end
      start_time
    end

    
    def end_time(params=nil)
      if params
        ups = filtered_usage_points(params)
      else
        ups = self.usage_points
      end
      end_time = ups[0].end_time
      ups.each do |up|
        end_time = [end_time, up.end_time].max
      end
      end_time
    end
		
	end
end



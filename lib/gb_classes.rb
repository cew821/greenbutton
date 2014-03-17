module GreenButtonClasses
  require './lib/helpers.rb'
  require 'nokogiri'
  
  Rule = Helper::Rule
  RULES = [
    Rule.new(:href, "./link[@rel='self']/@href", :string),
    Rule.new(:parent_href, "./link[@rel='up']/@href", :string),
    Rule.new(:id, "./id", :string),
    Rule.new(:title, "./title", :string),
    Rule.new(:date_published, "./published", :datetime),
    Rule.new(:date_updated, "./updated", :datetime)
  ]
    
  
  class GreenButtonEntry
    attr_accessor :id, :title, :href, :published, :updated, :parent_href, :related_hrefs, :other_related
    
    def initialize(entry_xml, parent)
      if !entry_xml.nil?
        @entry_xml = entry_xml
        self.related_hrefs = []
        self.other_related = []
        pre_rule_assignment(parent)
        assign_rules
        find_related_entries
      end
    end
    
    def pre_rule_assignment(parent)
      raise self.class + 'failed to implement pre_rule_assignment'
    end
    
    def additional_rules
      []
    end
    
    def doc
      self.usage_point.doc
    end
    
    def find_by_href(href)
      doc.xpath("//link[@rel='self' and @href='#{href}']/..")[0]
    end
    
    def assign_rules
      (RULES + additional_rules).each do |rule|
        create_attr(rule.attr_name)
        rule_xml = @entry_xml.xpath(rule.xpath)
        value = rule_xml.empty? ? nil : rule_xml.text
        translated_value = value.nil? ? nil : Helper.translate(rule.type, value)
        self.send(rule.attr_name.to_s+"=", translated_value)
      end
    end
    
    def find_related_entries
      self.related_hrefs = []
      @entry_xml.xpath("./link[@rel='related']/@href").each do |href|
        if /\/\d+$/i.match(href.text)
          related_entry = find_by_href(href.text)
          if related_entry
            parse_related_entry(related_entry)
            self.related_hrefs << href.text
          else
            warn 'no link found for href: ' + href.text
          end
        else  
          doc.xpath("//link[@rel='up' and @href='#{href.text}']").each do |link|
            self.related_hrefs << link.attr('href')
            parse_related_entry(link.parent)
          end
        end
      end
    end
    
    def parse_related_entry(entry_xml)
      name = get_related_name(entry_xml)
      classParser = GreenButtonClasses.const_get(name)
      if !classParser.nil?
        self.add_related(Helper.underscore(name), classParser.new(entry_xml, self))
      else
        other_related.push(xml)
      end
    end 
    
    def add_related(type, parser)
      raise self.class + ' does not have any recognized relations.'
    end
    
    private 
    
      def get_related_name(xml)
        name = nil
        xml.xpath('./content').children.each do |elem|
          if elem.name != 'text'
            name = elem.name
            break
          end
        end
        name
      end
      
      def alt_link(href)
        # SDGE links map as .../MeterReading to .../MeterReading/\d+
        regex =  Regexp.new(href + '\/\d+$')
        related_link = doc.xpath("//link[@rel='self']").select do |e| 
          if e['href'] =~ regex 
            e.parent
          end
        end
        related_link[0]
      end 
    
      def create_method( name, &block )
        self.class.send( :define_method, name, &block )
      end
    
      def create_attr( name )
        create_method( "#{name.to_s}=".to_sym ) { |val| 
          instance_variable_set( "@" + name.to_s, val)
        }
        create_method( name.to_sym ) { 
          instance_variable_get( "@" + name.to_s ) 
        }
      end
    
  end
  
  class UsagePoint < GreenButtonEntry
    attr_accessor :local_time_parameters, :meter_readings, :electric_power_usage_summaries, 
                  :electric_power_quality_summaries, :green_button
   
    def pre_rule_assignment(parent)
      self.green_button = parent
      self.meter_readings = []
      self.electric_power_quality_summaries = []
      self.electric_power_usage_summaries = []
    end
    
    def doc
      self.green_button.doc
    end
    
    def add_related(type, parser)
      case type
      when 'local_time_parameters'
        self.local_time_parameters = parser
      when 'meter_reading', 'electric_power_usage_summary', 'electric_power_quality_summary'
        self.send(Helper.pluralize(type)) << parser
      else 
        raise 'Not a recognized relation for UsagePoint: ' + type
      end
    end
    
    def additional_rules
      [ Rule.new(:service_kind, "//ServiceCategory/kind", :ServiceKind) ]
    end
    
    def customer_id
      if @customer_id.nil?
        match = /\/([^\/]+)\/UsagePoint/i.match(self.href)
        @customer_id = match.nil? ? nil : match[1]
      end
      @customer_id
    end
    
  end
  
  class MeterReading < GreenButtonEntry
    attr_accessor :reading_type, :interval_blocks, :usage_point
    
    def pre_rule_assignment(parent)
      self.usage_point = parent
      self.interval_blocks = []
    end
    
    def add_related(type, parser)
      case type
      when 'reading_type'
        self.reading_type = parser
      when 'interval_block'
        self.interval_blocks << parser
      else
        raise 'Not a recognized relation for MeterReading'
      end
    end
  end
  
  class ReadingType < GreenButtonEntry
    attr_accessor :meter_reading
    ATTRS = ['accumulationBehaviour', 'commodity', 'currency', 'dataQualifier', 'flowDirection', 'intervalLength',
        'kind', 'phase', 'powerOfTenMultiplier', 'timeAttribute', 'uom']
    
    def pre_rule_assignment(parent)
      self.meter_reading = parent
    end
    
    def doc
      self.meter_reading.doc
    end

    def additional_rules
      rules = []
      ATTRS.each do |attr|
        rules << Rule.new( Helper.underscore(attr).to_sym, './/'+attr, :integer )
      end
      rules
    end
  end
  
  class ElectricPowerUsageSummary < GreenButtonEntry
    attr_accessor :usage_point
    ATTRS = ['billLastPeriod', 'billToDate', 'costAdditionalLastPeriod', 'currency', 
      'qualityOfReading', 'statusTimeStamp']
    
    def pre_rule_assignment(parent)
      self.usage_point = parent
    end
    
    def additional_rules
      rules = [
        Rule.new(:bill_duration, ".//duration", :integer),
        Rule.new(:bill_start, ".//start", :unix_time),
        Rule.new(:last_power_ten, ".//overallConsumptionLastPeriod/powerOfTenMultiplier", :integer),
        Rule.new(:last_uom, ".//overallConsumptionLastPeriod/uom", :integer),
        Rule.new(:last_value, ".//overallConsumptionLastPeriod/value", :integer),
        Rule.new(:current_power_ten, ".//currentBillingPeriodOverAllConsumption/powerOfTenMultiplier", :integer),
        Rule.new(:current_uom, ".//currentBillingPeriodOverAllConsumption/uom", :integer),
        Rule.new(:current_value, ".//currentBillingPeriodOverAllConsumption/value", :integer),   
        Rule.new(:current_timestamp, ".//currentBillingPeriodOverAllConsumption/timeStamp", :unix_time)   
      ]
      ATTRS.each do |attr|
        rules << Rule.new( Helper.underscore(attr).to_sym, '//'+attr, :integer )
      end
      rules
    end
  end
  
  class ElectricPowerQualitySummary < GreenButtonEntry
    attr_accessor :usage_point
    def pre_rule_assignment(parent)
      self.usage_point = parent
    end
  end
  
  class LocalTimeParameters < GreenButtonEntry
    attr_accessor :usage_point
    
    def pre_rule_assignment(parent)
      self.usage_point = parent
    end
    
    def additional_rules
      [
        Rule.new(:dst_end_rule, ".//dstEndRule", :string),
        Rule.new(:dst_offset, ".//dstOffset", :integer),
        Rule.new(:dst_start_rule, ".//dstStartRule", :string),
        Rule.new(:tz_offset, ".//tzOffset", :integer)
      ]
    end
  end
  
  class IntervalBlock < GreenButtonEntry
    attr_accessor :meter_reading
    
    def pre_rule_assignment(parent)
      self.meter_reading = parent
    end
    
    def additional_rules
      [
        Rule.new(:start_time, './/interval/start', :unix_time),
        Rule.new(:duration, './/interval/duration', :integer)
      ]
    end
    
    def doc
      self.meter_reading.doc
    end
    
    def end_time
      self.start_time + self.duration
    end
    
    def power_of_ten_multiplier
      self.meter_reading.reading_type.power_of_ten_multiplier
    end
    
    def reading_at_time(time)
      if (time >= self.start_time) && (time < end_time)
        @entry_xml.xpath('.//IntervalReading').each do |interval_reading|
           intervalReading = IntervalReading.new(interval_reading)
           if (intervalReading.start_time <= time) && (intervalReading.end_time > time)
             return intervalReading
           end
        end   
      end
    end
    
    def value_at_time(time)
      reading_at_time(time).value*10**power_of_ten_multiplier
    end
    
    def total
      if @total.nil?
        @total = sum
      end
      @total
    end
    
    def average_interval_value
      total/n_readings
    end
    
    def n_readings
      @entry_xml.xpath('.//IntervalReading').length
    end
    
    def sum(starttime=nil, endtime=nil)
      starttime = starttime.nil? ? self.start_time : starttime.utc
      endtime = endtime.nil? ? self.end_time : endtime.utc
      sum = 0
      @entry_xml.xpath('.//IntervalReading').each do |interval_reading|
        intervalReading = IntervalReading.new(interval_reading)
        if intervalReading.start_time >= starttime && intervalReading.start_time < endtime
          if intervalReading.end_time <= endtime
            sum += intervalReading.value
          else
            ratio = (intervalReading.end_time.to_i - endtime.to_i)/intervalReading.duration
            sum += ratio*intervalReading.value
            break
          end
        end
      end
      sum*10**power_of_ten_multiplier  
    end  
  end
  
  class IntervalReading
    def initialize(reading_xml)
      @reading_xml = reading_xml
    end
    
    def value
      @reading_xml.xpath('./value').text.to_f
    end
    
    def start_time
      Time.at(@reading_xml.xpath('./timePeriod/start').text.to_i).utc
    end
    
    def duration
      @reading_xml.xpath('./timePeriod/duration').text.to_i
    end
    
    def end_time
      start_time + duration
    end
  end
  
end
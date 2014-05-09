module GreenButtonClasses
  require_relative 'helpers.rb'
  require 'nokogiri'
  require 'pry'
  
  Rule = Helper::Rule
  RULES = {
    href: Rule.new(:href, "./link[@rel='self']/@href", :string),
    parent_href: Rule.new(:parent_href, "./link[@rel='up']/@href", :string),
    id: Rule.new(:id, "./id", :string),
    title: Rule.new(:title, "./title", :string),
    date_published: Rule.new(:date_published, "./published", :datetime),
    date_updated: Rule.new(:date_updated, "./updated", :datetime)
  }
    
  class GreenButtonEntry
    attr_accessor :related_hrefs, :other_related, :href_from_parent
    
    def initialize(href_from_parent, entry_node, parent)
      self.href_from_parent = href_from_parent
      @entry_node = entry_node
      self.related_hrefs = []
      self.other_related = []
      create_attributes
      pre_rule_assignment(parent)
      get_related_links
    end
    
    def create_attributes
      all_rules.each_pair do |attr, rule|
        create_attr(attr)
      end
    end
    
    def entry_node
      if @entry_node.nil?
        @entry_node = find_by_href(self.href_from_parent).remove
      end
      @entry_node
    end
    
    def pre_rule_assignment(parent)
      warn self.class + 'failed to implement pre_rule_assignment'
    end
    
    def additional_rules
      {}
    end
    
    def all_rules
      RULES.merge(additional_rules)
    end
    
    def doc
      self.usage_point.doc
    end
    
    def find_by_href(href)
      doc.xpath("//link[@rel='self' and @href='#{href}']/..")[0]
    end
    
    def assign_rule(attr_name)
      rule = all_rules[attr_name]
      rule_xml = entry_node.xpath(rule.xpath)
      value = rule_xml.empty? ? nil : rule_xml.text
      translated_value = value.nil? ? nil : Helper.translate(rule.type, value)
      self.send(rule.attr_name.to_s+"=", translated_value)
      translated_value
    end
    
    def get_related_links
      self.related_hrefs = []
      entry_node.xpath("./link[@rel='related']/@href").each do |href|
        if /\/\d+$/i.match(href.text)
          add_related_link(href.text)
        else  
          many_related = doc.xpath("//link[@rel='up' and @href='#{href.text}']")
          many_related = alt_links(href.text) if many_related.length == 0
          many_related.each do |link|
            add_related_link(link.attr('href'), link.parent.remove)
          end
        end
      end
    end
    
    def add_related_link(href, entry_node = nil)
      self.related_hrefs << href
      name = get_related_name(href)
      classParser = GreenButtonClasses.const_get(name)
      if !classParser.nil?
        self.add_related_entry(Helper.underscore(name), classParser.new(href, entry_node, self))
      else
        other_related.push([href, entry_node])
      end      
    end
    
    def add_related_entry(type, parser)
      warn self.class + ' does not have any recognized relations.'
    end
    
    private 
    
      def get_related_name(href)
        regex = /(\w+)(\/\d+)*$/
        m = regex.match(href)
        if !m.nil?
          return m[1]
        end
        nil
      end
      
      def alt_links(href)
        # SDGE links map as .../MeterReading to .../MeterReading/\d+
        regex =  Regexp.new(href + '\/\d+$')
        related_links = doc.xpath("//link[@rel='self']").select do |e| 
          if e['href'] =~ regex 
            e.parent
          end
        end
        related_links
      end
    
      def create_method(name, &block )
        self.class.send(:define_method, name, &block )
      end
    
      def create_attr( name )
        create_method( "#{name.to_s}=".to_sym ) { |val| 
          instance_variable_set( "@" + name.to_s, val)
        }
        create_method( name.to_sym ) { 
          val = instance_variable_get( "@" + name.to_s ) 
          if val == false
            val = assign_rule(name)
            instance_variable_set( "@" + name.to_s, val)
          end
          val
        }
        instance_variable_set( "@" + name.to_s, false)
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
    
    def add_related_entry(type, parser)
      case type
      when 'local_time_parameters'
        self.local_time_parameters = parser
      when 'meter_reading', 'electric_power_usage_summary', 'electric_power_quality_summary'
        self.send(Helper.pluralize(type)) << parser
      else 
        warn 'Not a recognized relation for UsagePoint: ' + type
      end
    end
    
    def additional_rules
      { service_kind: Rule.new(:service_kind, ".//ServiceCategory/kind", :ServiceKind) }
    end
    
    def customer_id
      if @customer_id.nil?
        match = /\/([^\/]+)\/UsagePoint/i.match(self.href)
        @customer_id = match.nil? ? nil : match[1]
      end
      @customer_id
    end
    
    def start_time
      start_time = Time.now
      self.meter_readings.each do |mr|
        mr.interval_blocks.each do |ib|
          start_time = [ib.start_time, start_time].min
        end
      end
      start_time
    end

    def end_time
      end_time = self.meter_readings[0].interval_blocks[0].end_time
      self.meter_readings.each do |mr|
        mr.interval_blocks.each do |ib|
          end_time = [ib.end_time, end_time].max
        end
      end 
      end_time
    end
    
  end
  
  class MeterReading < GreenButtonEntry
    attr_accessor :reading_type, :interval_blocks, :usage_point
    
    def pre_rule_assignment(parent)
      self.usage_point = parent
      self.interval_blocks = []
    end
    
    def add_related_entry(type, parser)
      case type
      when 'reading_type'
        self.reading_type = parser
      when 'interval_block'
        self.interval_blocks << parser
      else
        warn 'Not a recognized relation for MeterReading'
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
      rules = {}
      ATTRS.each do |attr|
        sym = Helper.underscore(attr).to_sym
        rules[sym] = Rule.new(sym , './/'+attr, :integer )
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
      rules = {
        bill_duration: Rule.new(:bill_duration, ".//duration", :integer),
        bill_start: Rule.new(:bill_start, ".//start", :unix_time),
        last_power_ten: Rule.new(:last_power_ten, ".//overallConsumptionLastPeriod/powerOfTenMultiplier", :integer),
        last_uom: Rule.new(:last_uom, ".//overallConsumptionLastPeriod/uom", :integer),
        last_value: Rule.new(:last_value, ".//overallConsumptionLastPeriod/value", :integer),
        current_power_ten: Rule.new(:current_power_ten, ".//currentBillingPeriodOverAllConsumption/powerOfTenMultiplier", :integer),
        current_uom: Rule.new(:current_uom, ".//currentBillingPeriodOverAllConsumption/uom", :integer),
        current_value: Rule.new(:current_value, ".//currentBillingPeriodOverAllConsumption/value", :integer),   
        current_timestamp: Rule.new(:current_timestamp, ".//currentBillingPeriodOverAllConsumption/timeStamp", :unix_time)   
      }
      ATTRS.each do |attr|
        sym = Helper.underscore(attr).to_sym
        rules[sym] = Rule.new(sym , './/'+attr, :integer )
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
      {
        dst_end_rule: Rule.new(:dst_end_rule, ".//dstEndRule", :string),
        dst_offset: Rule.new(:dst_offset, ".//dstOffset", :integer),
        dst_start_rule: Rule.new(:dst_start_rule, ".//dstStartRule", :string),
        tz_offset: Rule.new(:tz_offset, ".//tzOffset", :integer)
      }
    end
  end
  
  class IntervalBlock < GreenButtonEntry
    attr_accessor :meter_reading
    
    def pre_rule_assignment(parent)
      self.meter_reading = parent
    end
    
    def additional_rules
      {
        start_time: Rule.new(:start_time, './/interval/start', :unix_time),
        duration: Rule.new(:duration, './/interval/duration', :integer)
      }
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
        entry_node.xpath('.//IntervalReading').each do |interval_reading|
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
      entry_node.xpath('.//IntervalReading').length
    end
    
    def sum(starttime=nil, endtime=nil)
      starttime = starttime.nil? ? self.start_time : starttime.utc
      endtime = endtime.nil? ? end_time : endtime.utc
      sum = 0
      entry_node.xpath('.//IntervalReading').each do |interval_reading|
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
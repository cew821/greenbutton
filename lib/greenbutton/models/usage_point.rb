module GreenButton
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
      green_button.doc
    end

    def add_related_entry(type, parser)
      case type
      when 'local_time_parameters'
        self.local_time_parameters = parser
      when 'meter_reading', 'electric_power_usage_summary', 'electric_power_quality_summary'
        self.send(pluralize(type)) << parser
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
end

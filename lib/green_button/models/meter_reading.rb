module GreenButton
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
end

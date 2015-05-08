module GreenButton
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
end

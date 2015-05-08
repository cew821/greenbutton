module GreenButton
  class ElectricPowerQualitySummary < GreenButtonEntry
    attr_accessor :usage_point
    def pre_rule_assignment(parent)
      self.usage_point = parent
    end
  end
end

module GreenButton
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
        sym = underscore(attr).to_sym
        rules[sym] = Rule.new(sym , './/'+attr, :integer )
      end
      rules
    end
  end
end

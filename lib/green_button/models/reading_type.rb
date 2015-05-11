module GreenButton
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
        sym = underscore(attr).to_sym
        rules[sym] = Rule.new(sym , ".//#{attr}", :integer )
      end
      rules
    end
  end
end

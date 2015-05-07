module GreenButton
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
end

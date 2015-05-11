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
      computed_value(reading_at_time(time).value)
    end

    def total
      @total ||= sum
    end

    def average_interval_value
      total / num_of_readings
    end

    def num_of_readings
      entry_node.xpath('.//IntervalReading').length
    end

    def sum(starttime = start_time, endtime = end_time)
      starttime = starttime.utc
      endtime = endtime.utc
      reading_sum = interval_readings.reduce(0) do |sum, interval_reading|
        intervalReading = IntervalReading.new(interval_reading)
        if intervalReading.start_time >= starttime && intervalReading.start_time < endtime
          if intervalReading.end_time <= endtime
            sum += intervalReading.value
          else
            sum += interval_ratio(intervalReading, endtime)
            break
          end
        end
        sum
      end
      computed_value(reading_sum)
    end

    def interval_readings
      @interval_readings ||= entry_node.xpath('.//IntervalReading')
    end

    def interval_ratio(reading, endtime)
      ratio = (reading.end_time.to_i - endtime.to_i) / reading.duration
      ratio * reading.value
    end

    def computed_value(value)
      value * 10 ** power_of_ten_multiplier
    end
  end
end

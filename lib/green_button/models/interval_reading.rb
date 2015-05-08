module GreenButton
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

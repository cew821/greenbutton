require 'spec_helper'

describe GreenButton do
  it "has web and file loading methods" do
    expect(GreenButton).to respond_to(:load_xml_from_file)
    expect(GreenButton).to respond_to(:load_xml_from_web)
  end

	describe GreenButton::Parser do
	  let(:gb){ GreenButton.load_xml_from_file('spec/fixtures/sample_greenbutton_data.xml') }

	  it "should initialize" do
      expect(gb).to be_a(GreenButton::Parser)
    end
	  
	  describe :usage_point do
	    let(:usage_point){ gb.usage_points.first }
	    subject { usage_point }
	    it "should have at least one usage_point" do
        expect(gb.usage_points.first.class).to eq GreenButtonClasses::UsagePoint
        expect(gb.usage_points.count).to be > 0
      end
  
      its(:service_kind){ should eq(:electricity) }
      its(:id){ should eq("urn:uuid:4217A3D3-60E0-46CD-A5AF-2A2D091F397E") }
      its(:customer_id){ should eq("9b6c7063") }
      its(:href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01") }
      its(:parent_href){ should eq("RetailCustomer/9b6c7063/UsagePoint") }
      its(:title){ should eq("Coastal Single Family") }
      its(:date_published){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) }
      its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) }
  
      it "knows its related hrefs" do
        expect(usage_point.related_hrefs).to include "RetailCustomer/9b6c7063/UsagePoint/01/MeterReading"
        expect(usage_point.related_hrefs).to include "RetailCustomer/9b6c7063/UsagePoint/01/ElectricPowerUsageSummary"
        expect(usage_point.related_hrefs).to include "LocalTimeParameters/01"
      end
      
      it "has defined local_time_parameters" do
        expect(usage_point.local_time_parameters).to be_a(GreenButtonClasses::LocalTimeParameters)
      end
      
      it "has one electric power usage summary" do
        expect(usage_point.electric_power_usage_summaries.length).to eq(1)
      end
      
      it "has no electric power quality summaries" do
        expect(usage_point.electric_power_quality_summaries.length).to eq(0)
      end
      
      it "has one meter reading" do
        expect(usage_point.meter_readings.length).to eq(1)
      end
	  
      describe :local_time_parameters do
        let(:local_time_parameters) { usage_point.local_time_parameters }
        subject{ local_time_parameters }
        
        its(:id){ should eq("urn:uuid:FE317A0A-F7F5-4307-B158-28A34276E862") }
        its(:href){ should eq("LocalTimeParameters/01") }
        its(:parent_href){ should eq("LocalTimeParameters") }
        its(:title){ should eq("DST For North America") }
        its(:date_published){ should eq(DateTime.parse("2012-10-24T00:00:00Z").to_time.utc) }
        its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) } 
        its(:dst_end_rule){ should eq("B40E2000") }
        its(:dst_offset){ should eq(3600) }
        its(:dst_start_rule){ should eq("360E2000") }
        its(:tz_offset){ should eq(-28800) } 
      end	  
      
      describe :electric_power_usage_summary do
        let(:electric_power_usage_summary) { usage_point.electric_power_usage_summaries.first }
        subject{ electric_power_usage_summary }
        
        ['billLastPeriod', 'billToDate', 'costAdditionalLastPeriod', 'currency', 
        'qualityOfReading', 'statusTimeStamp']
        
        it{ should be_a GreenButtonClasses::ElectricPowerUsageSummary }
        its(:id){ should eq("urn:uuid:429EAE17-A8C7-4E7F-B101-D66173B2166C") }
        its(:href){ should eq("RetailCustomer/9b6c7063/ElectricPowerUsageSummary/01") }
        its(:parent_href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01/ElectricPowerUsageSummary") }
        its(:title){ should eq("Usage Summary") }
        its(:date_published){ should eq(DateTime.parse("2012-10-24T00:00:00Z").to_time.utc) }
        its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) } 
        its(:bill_duration){ should eq(2592000) }
        its(:bill_start){ should eq(Time.at(1320130800).utc) }
        its(:last_power_ten){ should eq(nil) }
        its(:last_uom){ should eq(nil) }
        its(:last_value){ should eq(nil) }
        its(:current_power_ten){ should eq(0) }
        its(:current_uom){ should eq(72) }
        its(:current_value){ should eq(610314) }
        its(:current_timestamp){ should eq(Time.at(1325401200).utc) }
      end
  	  
  	  describe :meter_reading do
  	    let(:meter_reading) { usage_point.meter_readings[0] }
  	    subject{ meter_reading }
  	    it { should be_a(GreenButtonClasses::MeterReading) }
  	    
        its(:id){ should eq("urn:uuid:9BCDAB06-6690-46A3-9253-A451AF4077D8") }
        its(:href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01") }
        its(:parent_href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01/MeterReading") }
        its(:title){ should eq("Hourly Electricity Consumption") }
        its(:date_published){ should eq(DateTime.parse("2012-10-24T00:00:00Z").to_time.utc) }
        its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) }	          
         
        it "has one ReadingType" do
          expect(meter_reading.reading_type).to be_a(GreenButtonClasses::ReadingType)
        end
        
        it "has one IntervalBlock" do
          expect(meter_reading.interval_blocks.length).to eq(1)
        end
        
        describe :reading_type do
          let(:reading_type) { meter_reading.reading_type }
          subject{ reading_type }
          
          its(:id){ should eq("urn:uuid:BEB04FF1-6294-4916-95AC-5597070C95D4") }
          its(:href){ should eq("ReadingType/07") }
          its(:parent_href){ should eq("ReadingType") }
          its(:title){ should eq("Energy Delivered (kWh)") }
          its(:date_published){ should eq(DateTime.parse("2012-10-24T00:00:00Z").to_time.utc) }
          its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) } 
          its(:accumulation_behaviour){ should eq(4) }
          its(:commodity){ should eq(1) }
          its(:currency){ should eq(840) }
          its(:data_qualifier){ should eq(12) }
          its(:flow_direction){ should eq(1) }
          its(:kind){ should eq(12) }
          its(:phase){ should eq(769) }
          its(:power_of_ten_multiplier){ should eq(0) }
          its(:time_attribute){ should eq(0) }
          its(:uom){ should eq(72) }
        end      
        
        describe :interval_block do
          let(:interval_block) { meter_reading.interval_blocks[0] }
          subject{ interval_block }
          
          it { should be_a(GreenButtonClasses::IntervalBlock) }
          its(:id){ should eq("urn:uuid:EE0EC179-2726-43B1-BFE2-40ACC6A8901B") }
          its(:href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01/IntervalBlock/0173") }
          its(:parent_href){ should eq("RetailCustomer/9b6c7063/UsagePoint/01/MeterReading/01/IntervalBlock") }
          its(:title){ should eq("") }
          its(:date_published){ should eq(DateTime.parse("2012-10-24T00:00:00Z").to_time.utc) }
          its(:date_updated){ should eq(DateTime.parse('2012-10-24T00:00:00Z').to_time.utc) } 
          its(:start_time){ should eq(Time.at(1293868800).utc) }
          its(:duration){ should eq(2678400) }
          its(:end_time){ should eq(Time.at(1293868800+2678400).utc) }
          
          it "calculates correct total" do
            expect(interval_block.total).to eq(291018.0)
          end
          
          it "calculates correct average" do
            expect(interval_block.average_interval_value).to eq(291018.0/362.0)
          end
          
          it "calculates correct sum over time interval" do
            date1 = Time.at(1293915600).utc
            date2 = Time.at(1293922800).utc
            expect(interval_block.sum(date1, date2)).to eq(852+798)
          end
        
          it "returns correct value at given time" do
            expect(interval_block.value_at_time(Time.at(1293919600).utc)).to eq(798)
          end
          
          describe :interval_reading do
            let(:interval_reading){ interval_block.reading_at_time(Time.at(1293919600).utc) }
            subject{ interval_reading }
            its(:duration){ should eq(3600) }
            its(:start_time){ should eq(Time.at(1293919200).utc) }
            its(:end_time){ should eq(Time.at(1293919200+3600).utc) }
            its(:value){ should eq(798) }
          end
        end
  	  end
	  end
	end
end
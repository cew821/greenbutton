# find meter readings  associated with a given usage point


loader = GreenButton::Loader.new
doc = loader.load_xml_from_web("http://services.greenbuttondata.org:80/DataCustodian/espi/1_1/resource/RetailCustomer/1/DownloadMyData")



doc.xpath('//UsagePoint').each do |usage_point|
	puts usage_point.inspect
	
	# get each related link for this usage point 
	usage_point.xpath('../../link[@rel="related"]/@href').each do |href|
		local_link = href
		
		#find the local time parameter if there is one
		time_parameters = doc.xpath("//LocalTimeParameters/../../link[@rel='self' and @href='#{local_link}']/../content/LocalTimeParameters")

		usage_summaries = doc.xpath("//ElectricPowerUsageSummary/../../link[@rel='up' and @href='#{local_link}']/../content/ElectricPowerUsageSummary")
			# there could be more than one
		puts usage_summaries	

		# meter_readings = doc.xpath("//MeterReading/../../link[@rel='up' and @href='#{local_link}']/../content/MeterReading")
		# meter_readings.each do |reading|
		# 	reading.xpath("../")
		# 			# iterate through all the related links to find a readingtype, based ReadingType... whose self link matches the related link.

		# 			# get all the interval blocks

		# 			# for each meter reading, get the interval block

	end

end
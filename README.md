# Green Button

A [Green Button Data](http://services.greenbuttondata.org/) Parser written in Ruby.

[![Code Climate](https://codeclimate.com/github/cew821/greenbutton.png)](https://codeclimate.com/github/cew821/greenbutton)

## About

This is an implementation of a parser for [Green Button Data](http://services.greenbuttondata.org/), written in Ruby. Green Button is a data standard for communicating utility usage

This parser parsers a Green Button XML data file into a series of Ruby objects that can be used in your application

This software is free, and is released as open source under the MIT license. See license.txt for complete details.

## Installation

`$ gem install greenbutton`

## Usage

### Loading the XML

You can load Green Button XML from either a local file or remote source using the `GreenButton#load` method like so:

```ruby
require 'greenbutton'

# To load from file:
gb = GreenButton.load('PATH/TO/FILE.XML')

# To load from URL:
gb = GreenButton.load('https://services.greenbuttondata.org/DataCustodian/espi/1_1/resource/Batch/RetailCustomer/3/UsagePoint')
```

This code will load the Green Button XML from the given file or URL and parse it into a series of Ruby objects representing the data contained in the file.

Note: the above URL points to a sample Green Button data file representing a year's worth of electricity usage in one hour intervals for a sample home. More sample data can be found at http://services.greenbuttondata.org/sample-data.html

Depending on how large and complex the Green Button data file you load, this process could take a relatively long time, as the current implementation downloads the file and loads it into memory in order to parse it. Therefore, it is best to use this method outside of the request/response cycle if you are using it in a web application.

### Using the Data

Green Button data files are organized into `UsagePoints`, which represent the point at which the measurements in the file were made. Typically, these represent the meter at a home or business, but they could also be submeters or even individual appliances.

The sample file referenced above contains a single usage point (the meter outside of the home). You can use the following code to examine the data from the UsagePoint  more closely:

```ruby
usage_point = gb.usage_points.first
usage_point.service_kind                                          # => :electricity
usage_point.meter_readings.first.interval_blocks.count            # => 730
usage_point.meter_readings.first.interval_blocks.first.total      # => 5985.0
```

For more information on understanding the data contained in a typical Green Button file, see below.

### See It In Action

To see a very simple implementation of a Ruby application that uses the `greenbutton` gem, [check out the `GBSample` project on github](https://github.com/cew821/gbsample).

## Understanding Green Button Data

**This section is under construction. If you would like to help write better documentation for the library, get in touch!**

Green Button data files are organized according to the informational model shown below:

![Green Button Information Model](https://collaborate.nist.gov/twiki-sggrid/pub/SmartGrid/GreenButtonSDK/ESPISchemaOverview.png)

Essentially, you can think of a Green Button XML file as a dump from a relational database with several interconnected tables of information about a customer's electricity usage (in the most common cases, although the standard can be and is used to measure usage of other utilities such as gas and water).

## License

Please see [LICENSE](LICENSE) for licensing details.

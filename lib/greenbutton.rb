require 'nokogiri'
require 'open-uri'
require 'green_button/rule'
require 'green_button/helpers'
require 'green_button/models'
require 'green_button/parser'

module GreenButton
  # could also load this from the data custodian:feed
  # url = "http://services.greenbuttondata.org:80/DataCustodian/espi/1_1/resource/RetailCustomer/1/DownloadMyData"

  def self.load(path)
    xml_file = Nokogiri.XML(open(path))
    xml_file.remove_namespaces!
    Parser.new(xml_file)
  end
end

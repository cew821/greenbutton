require 'nokogiri'
require 'open-uri'
require 'greenbutton/rule'
require 'greenbutton/helpers'
require 'greenbutton/models'
require 'greenbutton/parser'

module GreenButton
  # could also load this from the data custodian:feed
  # url = "http://services.greenbuttondata.org:80/DataCustodian/espi/1_1/resource/RetailCustomer/1/DownloadMyData"

  def self.load(path)
    xml_file = Nokogiri.XML(open(path))
    xml_file.remove_namespaces!
    Parser.new(xml_file)
  end

  def self.load_xml_from_web(url)
    self.load(url)
  end

  def self.load_xml_from_file(path)
    self.load(path)
  end
end

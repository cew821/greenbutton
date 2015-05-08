require 'spec_helper'

describe GreenButton do
  it { is_expected.to respond_to(:load) }
  it { is_expected.to respond_to(:load_xml_from_file) }
  it { is_expected.to respond_to(:load_xml_from_web) }
end

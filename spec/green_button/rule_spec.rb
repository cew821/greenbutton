require 'spec_helper'

module GreenButton
  describe Rule do
    subject { Rule.new(:attr_name, 'xpath', :DateTime) }

    its(:attr_name) { is_expected.to eq :attr_name }
    its(:xpath) { is_expected.to eq 'xpath' }
    its(:type) { is_expected.to eq :DateTime }
  end
end

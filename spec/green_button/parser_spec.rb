require 'spec_helper'

module GreenButton
  describe Parser do
    let(:gb) { GreenButton.load('spec/fixtures/sample_greenbutton_data.xml') }

    it 'should initialize' do
      expect(gb).to be_a(Parser)
    end
  end
end

module GreenButtonHelper
  def greenbutton
    @greenbutton ||= GreenButton.load('spec/fixtures/sample_greenbutton_data.xml')
  end

  def example_usage_point
    greenbutton.usage_points.first
  end
end

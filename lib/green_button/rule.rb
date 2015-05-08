module GreenButton
  class Rule
    attr_accessor :attr_name, :xpath, :type

    def initialize(attr_name, xpath, type)
      @attr_name = attr_name
      @xpath = xpath
      @type = type
    end
  end
end

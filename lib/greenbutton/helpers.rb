module Helper
  require 'open-uri'
  
  SERVICE_KIND_HASH = {
    "0" => :electricity,
    "1" => :gas,
    "2" => :water,
    "3" => :time,
    "4" => :heat,
    "5" => :refuse,
    "6" => :sewerage,
    "7" => :rates,
    "8" => :tv_licence,
    "9" => :internet   
  }
  
  def self.translate(type, input_to_translate)
      if !input_to_translate.nil?
        case type
        when :ServiceKind
          translated = SERVICE_KIND_HASH[input_to_translate]
        when :datetime
          translated = DateTime.parse(input_to_translate).to_time
        when :unix_time
          translated = Time.at(input_to_translate.to_i).utc
        when :integer
          translated = input_to_translate.to_i
        else
          translated = input_to_translate
        end
        translated
      end
  end
  
  def self.pluralize(name)
    name = name.to_s.sub(/(y)$/i, 'ie')
    name += 's'
  end
  
  # from Rails http://apidock.com/rails/v4.0.2/ActiveSupport/Inflector/underscore
   def self.underscore(camel_cased_word)
     camel_cased_word.to_s.gsub(/::/, '/').
     gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
     gsub(/([a-z\d])([A-Z])/,'\1_\2').
     tr("-", "_").
     downcase
    end
	
	class Rule
    attr_accessor :attr_name, :xpath, :type

    def initialize(attr_name, xpath, type)
      @attr_name = attr_name
      @xpath = xpath
      @type = type
    end
  end
end
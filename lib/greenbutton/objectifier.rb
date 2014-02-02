module GreenButton
	class Objectifier
		
		def self.parse(xml, rule, object)
			value = xml.xpath(rule.xpath).text
			translated_value = type_translator(rule.type, value)
			object.send(rule.attr_name.to_s+"=", translated_value)
		end

		def self.parse_group(xml, rules, object)
			rules.each { |rule| parse(xml, rule, object) }
		end

		def self.type_translator(type, input_to_translate)
			case type
			when :ServiceKind
				keys = {
					"0" => :electricity,
					"1" => :gas,
					"2" => :water,
					"3" => :time,
					"4" => :heat,
					"5" => :refuse,
					"6" => :sewerage,
					"7" => :rates,
					"8" => :tv_licence,
					"9" => :internet }
				translated = keys[input_to_translate]
			else
				translated = input_to_translate
			end
			translated
		end
	end
end
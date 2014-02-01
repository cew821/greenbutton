module GreenButton
	class Objectifier
		
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
				keys[input_to_translate]
			end
		end
	end
end
extends Requirement
class_name CurrencyRequirement

#@export var currency: Currency
@export_enum("weaponPower") var currency: String
@export var value: int
#@export_enum(">=", "<=") var comparison_type: String = ">="
#@export_enum(">=", "<=") var compare_type: String = ">="


func check():
	var a = Game.find_property(currency)

	if a != null and a >= value:
		return true
	else:
		#print("%s/%s %s needed." % [a, value, currency])
		return false

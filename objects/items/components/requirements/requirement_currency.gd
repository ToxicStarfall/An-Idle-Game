extends Requirement
class_name RequirementCurrency

#@export var currency: Currency
#@export_enum("weaponPower", "knowledge") var currency: String
@export var currency: String
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


func _validate():
	if currency != "":
		if Game.find_property(currency) == false:
			push_error("Invalid currency: \"%s\"" % [currency])

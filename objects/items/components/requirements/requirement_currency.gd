extends Requirement
class_name RequirementCurrency

#@export var currency: Currency
@export_enum("knowledge", "power") var currency: String
#@export var currency: String
@export var value = 0
#@export_enum(">=", "<=") var comparison_type: String = ">="
#@export_enum(">=", "<=") var compare_type: String = ">="


func check():
	var a = Game.get_property(currency)

	if a != null and a >= value:
		return true
	else:
		#print("%s/%s %s needed." % [a, value, currency])
		return false


func _validate():
	if currency != "":
		if Game.get_property(currency) == false:
			push_error("Invalid currency: \"%s\"" % [currency])

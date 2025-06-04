extends RequirementCurrency
class_name CostCurrency


func apply():
	#var a = Game.find_property(currency)
	Game.subtract_resource(currency, value)
	pass

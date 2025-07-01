extends RequirementCurrency
class_name CostCurrency


func apply():
	#var a = Game.get_property(currency)
	#Game.subtract_resource(currency, value)
	Events.resource_removed.emit(currency, value)
	pass

extends RequirementCurrency
class_name CostCurrency


func apply():
	Events.resource_removed.emit(currency, value)
	pass

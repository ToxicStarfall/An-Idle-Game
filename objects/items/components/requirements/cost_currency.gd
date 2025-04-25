extends CurrencyRequirement
class_name CurrencyCost


func apply():
	#var a = Game.find_property(currency)
	Game.remove_resource(currency, value)
	pass

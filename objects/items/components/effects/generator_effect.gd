extends Resource
class_name GeneratorEffect
#extends ItemEffect

enum Modifier { ADD, SUBTRACT }

@export var type: String
@export var value: int
@export var modifier: Modifier = Modifier.ADD
#@export_enum("Add", "Subtract") var modifier: String = "Add"



func apply(generator_quantity):  # generator passes quantity on each cycle  NEED FIXING
	_custom_effect(generator_quantity)
	pass


func _custom_effect(multiplier = 1):
	var value = self.value * multiplier

	Events.resource_added.emit(type, value)
	#match modifier:
		#"Add":
			#Events.resource_added.emit(type, value)
		#"Subtract":
			#Events.resource_removed.emit(type, value)

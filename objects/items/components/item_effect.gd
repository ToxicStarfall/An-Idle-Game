extends Resource
class_name ItemEffect

#enum Modifiers { ADD, SUBTRACT }
@export var type: String
@export var value: int
@export_enum("Add", "Subtract") var modifier: String


func _init() -> void:
	_validate()
	pass


func apply():
	_custom_effect()
	pass


func _custom_effect():
	var property = Game.find_property(type)

	match modifier:
		"Add":
			property += value
		"Subtract":
			property -= value

	Game.add_resource(type, value)
	pass


func _validate():
	if value != 0:  # if there is a specified value, then make sure "type" is a existing property.
		if Game.find_property(type) == null:
			push_error("[WARNING] - Cannot find property \"%s\" in GameData." % [type])
	pass

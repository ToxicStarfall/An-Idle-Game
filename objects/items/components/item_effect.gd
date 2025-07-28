extends Resource
class_name ItemEffect

enum Modifier { ADD, SUBTRACT }

@export var type: String
@export var value: float
@export var modifier: Modifier = Modifier.ADD

var valid


func _init() -> void:
	_validate()


func apply():  # generator passes quantity on each cycle  NEED FIXING
	if valid:
		_custom_effect()


func _custom_effect():
	#var value = self.value * multiplier

	match modifier:
		Modifier.ADD:
			Events.resource_added.emit(type, value)
		Modifier.SUBTRACT:
			Events.resource_removed.emit(type, value)


func get_as_text():
	pass


func _validate():
	if value != 0:  # if there is a specified value, then make sure "type" is a existing property.
		if Game.get_property(type) == null:
			valid = false
			push_error("[WARNING] - Cannot find property \"%s\" in GameData." % [type])

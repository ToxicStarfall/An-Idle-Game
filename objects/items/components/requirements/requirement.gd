## DO NOT USE: This is just an abstract class.
extends Resource
class_name Requirement


func _init() -> void:
	_validate()
	pass


## Returns true/false if the requirement is met.
func check():
	pass


## Checks if this requirement is valid ( no null info ).
func _validate():
	pass

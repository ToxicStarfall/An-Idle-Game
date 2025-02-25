#@tool
extends Resource
class_name Item


@export_placeholder("Item Name") var name: String = ""
@export_multiline var description: String = "I am a description."


@export var costs: Array[ItemCost] = [] :
	get():
		return check_validity()
@export var requirements: Array[ItemRequirement] = []
@export var effects: Array[ItemEffect] = []


# Autofills the cost and requiremnets arrays with their respective sub-resource
#  UNUSED
func _init() -> void:
	if Engine.is_editor_hint():
		if costs.is_empty():
			costs.append( ItemCost.new() )
		if requirements.is_empty():
			requirements.append( ItemRequirement.new() )
		pass



func check_validity():
	return
	pass


func check_costs():
	var total_entries

	for entry in costs:
		total_entries += 1
		var entry_type = Game.find_property(entry.type)
		var entry_value = entry.value

		match entry_type:
			TYPE_FLOAT, TYPE_INT:
				pass
			TYPE_BOOL:
				pass
		#if entry_type == TYPE_INT:
			#pass
	pass


func check_requirements():
	pass

class_name FunctionHighlight
extends ItemEffect


#@export var requirements: Array[Requirement]
@export var unlocked: bool = false
@export var node_name: String


#func _ready() -> void:
	#pass

func apply():
	# If ui tutorial hint has already been interacted with, then ignore effect
	if GameData.ui_hint[node_name] == true:
		print("applied")
		Events.function_highlighted.emit(node_name)
	else:
		print("not_applied")
		pass

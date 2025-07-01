extends Event
class_name EventMessage


#@export var tooltip

func _init(message: String, tooltip_data: Resource = null) -> void:
	self.text = message
	self.tooltip_data = tooltip_data

class_name EventPopup
extends Event


func _init(message: String, tooltip_data: Resource = null, duration := 0.0) -> void:
	self.text = message
	self.tooltip_data = tooltip_data
	self.duration = duration


func call_event():
	super()

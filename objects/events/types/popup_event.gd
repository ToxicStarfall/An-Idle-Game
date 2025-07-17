class_name PopupEvent
extends Event
## Event class for quick mini event popups that may randomly happen
## ex: golden cookies from Cookie clicker


func _init(message: String, tooltip_data: Resource = null, duration := 0.0) -> void:
	self.text = message
	self.tooltip_data = tooltip_data
	self.duration = duration


func call_event():
	super()

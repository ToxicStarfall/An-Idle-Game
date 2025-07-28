class_name Event
extends Resource


#@export_multiline var text: String = "Generic event text."
#@export var tooltip_data: Resource
#
#@export_category("Event Info")
#@export var icon: Texture2D = preload("res://icon.svg")
#@export var title: String = "Event Title."
#@export_multiline var description: String = "Event details."
#@export var a: Array
#
#@export_category("Event Config")
##@export_enum("None", "Limited") var event_duration_type = "None"
#@export var duration: float = 0  ## How long this event should last in seconds.
#@export var dismissable: bool = false  ## Whether or not this event can be dissmissed and removed.



func call_event():
	Events.trigger_event.emit(self)
	pass

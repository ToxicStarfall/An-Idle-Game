class_name MessageEvent
extends Event


@export_category("Event Config")
@export var is_ambient := false  ## If true, this message is just for flavour.
@export var is_popup := false  ## If true, make a little text popup at click position.
## How long this event should last in seconds.  0 = Lasts forever.
@export var duration := 0.0
## Whether or not this event can be dissmissed and removed.
@export var dismissable: bool = false

@export_category("Event Info")
## Optional icon shown with the message.
@export var icon: Texture2D
## Text content of the message.
@export_multiline var text := "Generic message."
@export var tooltip_data: Resource


## Constructor for creating message dynamically.
func _init(message: String, tooltip_data: Resource = null, duration := 0.0) -> void:
	self.text = message
	self.tooltip_data = tooltip_data
	self.duration = duration


func popup():
	is_popup = true
	return self

func ambient():
	is_ambient = true;
	return self

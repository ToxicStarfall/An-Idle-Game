extends Event
class_name InteractionEvent


@export_category("Event Config")
## If true, make a little text popup at click position.
#@export var popup := false
## How long this event should last in seconds.  0 = Stays until removed by an interaction.
@export var duration := 0.0
## Whether or not this event can be dissmissed and removed.
#@export var dismissable: bool = false


@export_category("Event Info")
## If assigned, a interactable message is created which calls this event instead.
#@export var message: MessageEvent

## Optional image for the event.
@export var icon: Texture2D = preload("res://icon.svg")
@export var title: String = "Event Title."
@export_multiline var description: String = "Event details."

#@export var a: Array
#@export var dialog: String
@export var options: Array[EventOption]

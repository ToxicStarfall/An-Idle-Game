extends Node


signal new_message_event
signal new_interaction_event

signal event_option_selected(option)


var current_event: Event
#var queued_events = []


func _ready() -> void:
	Events.trigger_event.connect( _on_event_triggered )
	pass


func _on_event_triggered( event: Event ):
	if event is MessageEvent:
		if event.is_popup:
			_create_popup(event)
		else:
			new_message_event.emit(event)
			#Events.message_logged.emit( event )

	if event is InteractionEvent:
		current_event = event
		new_interaction_event.emit(event)


## Creates popup text which stays temproarily at mouse position.
func _create_popup(event):
	var msgnode = load("res://objects/events/types/message/popup_message_node.tscn").instantiate()
	msgnode.event = event
	get_tree().root.get_node("Main/%UserInterface").add_child(msgnode)
	msgnode.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	msgnode.text = event.text
	msgnode.position = get_viewport().get_mouse_position()
	msgnode.position += Vector2( -(msgnode.size.x/2), -1 * msgnode.size.y)
	msgnode.z_index = 2
	pass

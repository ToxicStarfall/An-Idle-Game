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
		new_message_event.emit(event)
		#Events.message_logged.emit( event )
		if event.is_popup:
			print("I have popup")
			# Create a popup message
			pass

	if event is InteractionEvent:
		current_event = event
		new_interaction_event.emit(event)

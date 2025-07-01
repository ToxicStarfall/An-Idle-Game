extends Node


var current_event: Event


func _ready() -> void:
	#Events.trigger_event.connect( _on_trigger_event )
	pass


func _on_trigger_event( event: Event ):
	# If an event message exists, send to EventLog
	if event.text:
		#print("")
		pass


#func call_event():
	#var a = load("res://objects/events/new_event.tres")
	#a.call_event()
	#pass

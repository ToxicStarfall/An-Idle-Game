class_name EventEffect
extends ItemEffect


@export var event: Event


func apply():
	event.call_event()  # Runs "Events.trigger_event,emit()"
	#Events.trigger_event.emit( event )
	pass

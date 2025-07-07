extends PanelContainer


var unlocked := false


@onready var EventCard = %EventCard
@onready var LogContainer = %LogContainer


func _ready() -> void:
	#Events.trigger_event.connect( _on_new_event )
	#Events.message_logged.connect( _on_message_logged )
	EventManager.new_message_event.connect( _on_new_message_event )
	EventManager.new_interaction_event.connect( _on_new_interaction_event )
	pass



#func _on_message_logged(event):
	#var message = preload("res://objects/events/types/message_event_node.tscn").instantiate()
	#message.event = event
	#message.text = event.text
	#LogContainer.add_child(message)
	#LogContainer.move_child(message, 0)
	#pass


func _on_new_message_event(event: MessageEvent):
	var message = preload("res://objects/events/types/message_event_node.tscn").instantiate()
	message.event = event
	message.text = event.text
	LogContainer.add_child(message)
	LogContainer.move_child(message, 0)
	pass


func _on_new_interaction_event(event: InteractionEvent):
	EventCard.show()
	#print(event)
	%Icon.texture = event.icon
	%Text.text = event.text
	pass



func unlock():
	unlocked = true


func _toggle_expand(expanded: bool):
	if expanded:
		pass
	else:
		pass


func _toggle_visibilty(visible: bool):
	if visible and unlocked:
		self.show()
		# play slide in effect
	else:
		self.hide()
		# play slide out effect

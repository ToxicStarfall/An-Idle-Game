extends PanelContainer


var unlocked := false


@onready var LogContainer = %LogContainer


func _ready() -> void:
	Events.trigger_event.connect( _on_new_event )
	pass


func _on_new_event(event):
	if event is EventMessage:
		_new_message(event)
		return
	if event is Event:
		_set_event_card(event)
		return


func _new_message(event):
	var message = preload("res://objects/events/types/event_message_node.tscn").instantiate()
	message.event = event
	message.text = event.text
	LogContainer.add_child(message)
	LogContainer.move_child(message, 0)
	pass


func _set_event_card(event):
	#print(event)
	%Icon.texture = event.icon
	%Text.text = event.text
	pass



func unlock():
	unlocked = true


func toggle_expand(expanded: bool):
	if expanded:
		pass
	else:
		pass


func toggle_visibilty(visible: bool):
	if visible and unlocked:
		self.show()
		# play slide in effect
	else:
		self.hide()
		# play slide out effect

extends PanelContainer


var unlocked := false


@onready var EventCard = %EventCard
@onready var LogContainer = %LogContainer



func _ready() -> void:
	EventManager.new_message_event.connect( _on_new_message_event )
	EventManager.new_interaction_event.connect( _on_new_interaction_event )
	pass



func _on_new_message_event(event: MessageEvent):
	var message = preload("res://objects/events/types/message/message_event_node.tscn").instantiate()
	message.event = event
	message.text = event.text
	LogContainer.add_child(message)
	LogContainer.move_child(message, 0)
	pass


func _on_new_interaction_event(event: InteractionEvent):
	EventCard.show()
	#print(event)
	%Icon.texture = event.icon
	%Text.text = event.description

	for option in event.options:
		var Option = load("res://objects/events/types/interaction/interaction_option.tscn").instantiate()
		Option.name = str(event.options.find(option))  # Button name is the index of the option in event.options
		Option.text = option.name  # Display text is event.option's name
		EventCard.get_node("%QuickActions").add_child( Option )
		Option.pressed.connect( func():
			# Resolve the event
			MessageEvent.new("This currently does nothing.").call_event()
			EventManager.event_option_selected.emit( Option.name )
		)
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

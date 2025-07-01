extends ItemNode
class_name GeneratorNode


#var item_resource: Generator
var generator_active = false


func _ready() -> void:
	if !visible or !item_resource:
		print("skipped initializtion on generator node, hiding node.")
		self.hide()
	else:  # OVERIDE
		item_resource.update_state.connect( _update_state )
		%NameLabel.text = item_resource.name
		%Timer.timeout.connect( _generate_complete )
		_update_state( item_resource.state )  # updates state to the default state set within this item's resource
	pass


func _process(_delta):
	if generator_active:
		%GenerateProgress.value = %Timer.wait_time - %Timer.time_left


func _on_pressed():  # OVERIDE
	item_resource.buy_generator(1)


func _update_state(state: Item.State):
	const State = Item.State
	super(state)  # Applies trasnparency/visibility
	match state: #item_resource.state:
		#State.LOCKED:
			#pass
		#State.UNLOCKED:
			#pass
		State.OWNED:
			self.self_modulate = Color(1, 1, 1)
			%QuantityLabel.text = "( Owned :  %s )" % [item_resource.quantity]
			if item_resource.quantity >= 1:
				# Only update info when activating generator
				if !generator_active:
					%Timer.wait_time = item_resource.generate_time
					%GenerateProgress.max_value = %Timer.wait_time
					%Timer.start()
					generator_active = true
			else:
				generator_active = false
				%Timer.stop()


#
func _generate_complete():
	# Update info every time generate completes a cycle
	%Timer.wait_time = item_resource.generate_time
	%GenerateProgress.max_value = %Timer.wait_time

	# Play generate currency effects
	item_resource.generate_currency()
	pass

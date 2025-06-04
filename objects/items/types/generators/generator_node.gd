extends ItemNode
class_name GeneratorNode


#var item_resource: Generator
#var hovered: bool = false


func _ready() -> void:
	if !visible or !item_resource:
		#print("skipped initializtion on generator node, hiding node.")
		self.hide()
	else:
		item_resource.update_state.connect( _update_state )
	pass


func _on_pressed():
	item_resource.buy()


func _update_state(state: Item.State):
	super(state)
	#print("state updated, visuals update")
	#const State = Item.State
	#match state: #item_resource.state:
		#State.LOCKED:
			#self.self_modulate = Color(0, 0, 0)
			##print("ASd")
		#State.UNLOCKED:
			#self.self_modulate = Color(0.7, 0.7, 0.7)
		#State.OWNED:
			#self.self_modulate = Color(1, 1, 1)

extends Item
class_name Research


## research time in miliseconds
@export var time: int = 0
@export var position_overide: Vector2


#func _set_state(new_state: Item.State):
	#super( new_state )
	# connector lines are updated in research_node.gd
	#pass

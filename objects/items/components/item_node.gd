extends Button
class_name ItemNode


@export var item_resource: Item
var hovered: bool = false

#@onready var on_ready = _on_ready()


func _init() -> void: #_on_ready():
	pressed.connect( _on_pressed )
	mouse_entered.connect( _on_mouse_entered )
	mouse_exited.connect( _on_mouse_exited )
	pass


func _ready() -> void:
	item_resource.update_state.connect( _update_state )
	#self.name = item_resource.resource_name  # Already set when loading resources( Game.initialize_game_resources() ).
	self.text = item_resource.name
	#_update_state( Item.State.LOCKED )
	_update_state( item_resource.state )
	pass


func _on_pressed():
	item_resource.buy()


func _on_mouse_entered():
	hovered = true
	Game.update_tooltip.emit( self, true )
	pass

func _on_mouse_exited():
	hovered = false
	Game.update_tooltip.emit( self, false )
	pass


func _update_state(state: Item.State):
	#print("state updated, visuals update")
	const State = Item.State
	match state: #item_resource.state:
		State.LOCKED:
			self.modulate = Color(0, 0, 0)
			#print("ASd")
		State.UNLOCKED:
			self.modulate = Color(0.7, 0.7, 0.7)
		State.OWNED:
			self.modulate = Color(1, 1, 1)

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

	if self is Button:  self.icon = item_resource.icon
	#self.name = item_resource.raw_name  # Already set when loading resources( Game.initialize_game_resources() ).
	#self.text = item_resource.name
	_update_state( item_resource.state )  # updates state to the default state set within this item's resource
	pass


func _on_pressed():
	item_resource.buy()


func _on_mouse_entered():
	hovered = true
	Events.request_tooltip.emit( self, item_resource, true )
	#print("a")

func _on_mouse_exited():
	hovered = false
	Events.request_tooltip.emit( self, item_resource, false )
	#print("b")


func _update_state(state: Item.State):
	const State = Item.State
	match state:
		State.LOCKED:
			self.modulate = Color(0, 0, 0)
			self.hide()
		State.UNLOCKED:
			self.modulate = Color(0.7, 0.7, 0.7)
			self.show()
		State.OWNED:
			self.modulate = Color(1, 1, 1)

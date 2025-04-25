extends Button
class_name ItemNode


var item_resource: Item


#@onready var on_ready = _on_ready()


func _init() -> void:#_on_ready():
	pressed.connect( _on_pressed )
	pass


func _ready() -> void:
	self.text = item_resource.name
	pass


func _on_pressed():
	item_resource.buy()
	pass


func _update_content():
	# apply visual changes
	pass

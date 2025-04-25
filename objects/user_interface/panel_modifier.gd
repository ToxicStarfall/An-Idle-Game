extends PanelContainer
class_name PanelModifier


@export var ToggleButton: Control
@export var toggled_content: Array[Control] = []

@export_group("control_parent")
@export var ControlParent: Control
@export var control_min_size_shown: Vector2
@export var control_min_size_hidden: Vector2

@export_group("split_container")
@export var SplitContainerNode: SplitContainer
@export var split_offset = 0


var collapse_state: bool = false
var state_locked: bool

var _size: float


@onready var on_ready = _on_ready()

func _on_ready():
	ToggleButton.gui_input.connect( _on_toggle_button_gui_input )
	toggle_state(false)
	print(ToggleButton)
	pass


func _ready():
	#ToggleButton.gui_input.connect( _on_toggle_button_gui_input )
	#toggle_state(false)
	#print(ToggleButton)
	pass


# Hides & shows certain control nodes when set to true/false
func toggle_state(value):
	if value == true:
		for i in toggled_content:
			i.show()
			ControlParent.custom_minimum_size = control_min_size_shown
			SplitContainerNode.dragging_enabled = true

	if value == false:
		for i in toggled_content:
			i.hide()
			ControlParent.custom_minimum_size = control_min_size_hidden
			SplitContainerNode.split_offset = split_offset
			SplitContainerNode.dragging_enabled = false


func _on_toggle_button_gui_input(event: InputEvent) -> void:
	#print("button hovered")
	if event is InputEventMouseButton:
		#print("button toggled")
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			collapse_state = bool((int(collapse_state)- 1) * -1)
			toggle_state(collapse_state)
			pass

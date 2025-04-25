#extends PanelContainer
extends PanelModifier



func _ready() -> void:
	pass



# Hides & shows certain control nodes when set to true/false
#func _toggle_state(value):
	#if value == true:
		#for i in toggled_content:
			#i.show()
			#get_parent().get_parent().custom_minimum_size.x = 380
			#get_parent().get_parent().get_parent().dragger_visibility = SplitContainer.DRAGGER_VISIBLE
#
	#if value == false:
		#for i in toggled_content:
			#i.hide()
			#get_parent().get_parent().custom_minimum_size.x = 40
			#get_parent().get_parent().get_parent().split_offset = 540
			#get_parent().get_parent().get_parent().dragger_visibility = SplitContainer.DRAGGER_HIDDEN
#
#
#func _on_progress_bar_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			#state = bool((int(state)- 1) * -1)
			#_toggle_state(state)
			#pass

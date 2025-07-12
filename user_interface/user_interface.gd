extends Control


# Main menu, game, credits, etc...
var current_scene: Control
var scenes = []


# This runs after all children are loaded
func _ready() -> void:
	Events.user_interface_loaded.emit()
	pass

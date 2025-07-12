extends Node


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("save_game"):
		print("request game save")
		Events.game_saved.emit()

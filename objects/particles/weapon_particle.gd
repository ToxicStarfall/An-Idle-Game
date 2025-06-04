extends Sprite2D


var lifetime = 2.5
var time_passed = 0.0

var direction = Vector2(0, -1)
var spread = randf_range(-22.5, 22.5)  # total spread of 45 degrees
var gravity = Vector2(0, 350)
var frame_pos: int = randi_range(0, (hframes * vframes) - 1)
var initial_velocity: int = randi_range(100, 400)
var angular_velocity: int = randi_range(-210, 210)


func _ready() -> void:
	self.frame = frame_pos
	#var a = get_tree().create_tween()
	#a.tween_property()
	#a.tween_callback()

extends Resource
class_name Weapons


# MAIN
@export var Count: int = 0
@export var Power: float = 0.0
@export var PowerE: float = 0.0
@export var PC: float = 0.0
@export var PS: float = 0.0
@export var BasePC: int = 1	:
	set(_value):
		_update_weaponsPC()
@export var BasePS: int = 0

# STATS
@export var HighestPC: float = 0.0
@export var HighestPS: float = 0.0



func _init() -> void:
	_update_weaponsPC()


# SETTERS
func _update_weaponsPC():
	PC = BasePC
	#print(PC)
	# apply multipliers

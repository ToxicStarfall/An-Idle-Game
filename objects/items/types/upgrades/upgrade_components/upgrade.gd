extends Item
class_name Upgrade


#@export var cost: Array[ItemCost] = []
#@export var requirements: Array[ItemRequirement] = []



func _init() -> void:
	self.type = Type.UPGRADE
	pass

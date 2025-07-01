extends ItemEffect
class_name FunctionUnlock


#@export var requirements: Array[Requirement]
@export var unlocked: bool = false
@export var node_name: String
#@export var

func _ready() -> void:
	#get_scene
	#get_node( node_path ).visibility = unlocked
	#self.hide()
	#Events.item_bought.connect( unlock )
	#GameData.unlockables.set("0", self)
	pass

func apply():
	#_custom_effect(multiplier)

	Events.function_unlock.emit(node_name)
	pass


#func _custom_effect(multiplier):
	#pass

#func unlock():
	#var valid = true
	#for requirement in requirements:
		## cancel purchase if a requirement is not met
		#if requirement.check() == false:
			#valid = false
#
	#if valid:
		#self.show()

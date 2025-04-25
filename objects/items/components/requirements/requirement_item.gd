extends Requirement
class_name ItemRequirement

#@export var currency: Currency
## The target item to check.
@export var item: Item
## The desired item state to check for. If the item is in this state, this Requirment is passed.
@export var state: Item.State


func check():
	#var a = Game.find_item( item.name )
	#print(a.state," vs ", state)
	if item.state == state:
		return true
	else:
		return false


func _validate():
	pass

extends Requirement
class_name RequirementItem

## The target item to check.
@export var item: Item
## The desired item state to check for. If the item is in this state, this Requirment is passed.
@export var state: Item.State = Item.State.OWNED


## Constructor method to set this resource's properties
func setup(item := self.item, state := self.state):
	self.item = item
	self.state = state


func check():
	#var a = Game.find_item( item.name )
	#print(a.state," vs ", state)
	if item.state == state:
		return true
	else:
		return false


func _validate():
	pass

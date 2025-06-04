extends PanelContainer


@onready var Title = %TitleLabel
@onready var State = %OwnedLabel
@onready var Description = %DescriptionText
@onready var Costs = %CostText
@onready var Tags = %TagsText
@onready var Flair = %FlairText


func _ready() -> void:
	Game.update_tooltip.connect( _on_update_tooltip )


func _on_update_tooltip(target_node, visibility: bool):
	var item = target_node.item_resource

	_update_visibility(visibility)
	if visibility == true:
		_update_info(item)
		_update_position(target_node)


func _update_info(item):
	# Sets general item info
	if item is Item:
		match item.state:
			Item.State.UNLOCKED, Item.State.OWNED:
				Title.text = item.name
				Description.text = item.description
				#Costs.text = item._get_costs()
				State.text = ""
				Costs.text = str(item.costs)
				Tags.text = str(item.tags)
				Flair.text = item.flair
				pass
			Item.State.LOCKED:
				Title.text = "LOCKED ITEM"
				Description.text = "This item is locked."
				State.text = ""
				Costs.text = ""
				Tags.text = ""
				Flair.text = "You don't own this yet."
				pass

	# Sets Upgrade and Research specific info
	if item is Research or item is Upgrade:
		match item.state:
			Item.State.OWNED:
				State.text = "( Owned )"
				Costs.text = "BOUGHT"
				pass

	# Sets generator specific info
	if item is Generator:
		match item.state:
			Item.State.OWNED:
				State.text = "( Owned :  %s )" % [item.quantity]
				#Costs.text = "BOUGHT"
				pass

	# Add more spcific control types for different ui buttons/parts
	#if target_node is Button:
		#pass
	pass


func _update_position(target_node):
	self.position = target_node.position
	#target_node
	pass


func _update_visibility(visibility: bool):
	self.visible = visibility

extends PanelContainer


@onready var Title = %TitleLabel
@onready var State = %OwnedLabel
@onready var Description = %DescriptionText
@onready var Costs = %CostText
@onready var Tags = %TagsText
@onready var Flair = %FlairText


func _ready() -> void:
	#Game.update_tooltip.connect( _on_update_tooltip )
	Events.request_tooltip.connect( _on_update_tooltip )


func _on_update_tooltip(target_node, data, visibility: bool):
	var item = data
	#if target_node.get("tooltip_data"):
		#item = target_node.tooltip_data
	#else:
		#item = target_node.item_resource

	_update_visibility(visibility)
	if visibility == true:
		_update_info(item)
		#_update_position(target_node)


func _update_info(item):
	# Sets general item info
	if item is Item:
		match item.state:
			Item.State.OWNED:
				Title.text = item.name
				Description.text = item.description
				#State.text = ""
				Costs.text = ""
				Tags.text = str(item.tags)
				Flair.text = item.flair
				pass
			Item.State.UNLOCKED:#, Item.State.OWNED:
				Title.text = item.name
				Description.text = item.description
				#State.text = ""
				#Costs.text = "" # reset
				#var costs = item.get_costs()
				#for req in costs:
					#var color = "green"
					#if req.check() == false:
						#color = "red"
					#Costs.text += "[color=%s]%s[/%s]" % [ color, costs.pop_front(), color ]
				Costs.text = "[color=green]%s[/color]" % [item.get_costs()]
				Tags.text = str(item.tags.internal_tags)
				#Tags.text = str(item.tags.taglist)
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
				pass

	# Sets generator specific info
	if item is Generator:
		match item.state:
			Item.State.OWNED:
				State.text = "( Owned :  %s )" % [item.quantity]
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

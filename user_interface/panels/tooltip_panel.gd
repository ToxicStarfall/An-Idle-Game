extends Control


var hovered: bool = false


@onready var Title = %TitleLabel
@onready var State = %OwnedLabel
@onready var Description = %DescriptionText
@onready var Costs = %CostText
@onready var Tags = %TagsText
@onready var Flair = %FlairText


func _ready() -> void:
	self.hide()  # Hide on start
	Events.request_tooltip.connect( _on_update_tooltip )


func _on_update_tooltip(target_node, data, visibility: bool):
	if visibility == true:
		_update_info(data)
		_update_position(target_node)

	# PanelContainer is being funny. Force setting size to 85(minimum) for now.
	_update_visibility(visibility)
	self.size.y = 85


func _update_info(item):
	# Sets general item info
	if item is Item:
		match item.state:
			Item.State.OWNED:
				Title.text = item.name
				Description.text = item.description
				State.text = ""
				Costs.text = "OWNED"
				Tags.text = item.get_tags()
				Flair.text = item.flair
				pass
			Item.State.UNLOCKED:#, Item.State.OWNED:
				Title.text = item.name
				Description.text = item.description
				State.text = ""
				#Costs.text = "%s[/color]" % [item.get_costs()]
				Costs.text = item.get_costs()
				Tags.text = item.get_tags()
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
				#State.text = "( Owned )"
				pass

	# Sets generator specific info
	if item is Generator:
		match item.state:
			Item.State.OWNED:
				State.text = " [Owned :  %s]" % [item.quantity]
				Costs.text = item.get_costs()
				pass
	#match item.get_script().get_global_name():
		#"Item":
			#pass
		#"Upgrade", "Research":
			#pass
		#"Generator":
			#pass

	# Add more spcific control types for different ui buttons/parts
	#if target_node is Button:
		#pass


func _update_position(target_node):
	#var target_pos = target_node.get_screen_position()
	#self.position = Vector2(target_pos.x, target_pos.y - self.size.y)
	self.position = target_node.get_screen_position()
	self.position.y -= self.size.y  # Align tooltip bottom above target_node
	self.position.x += (target_node.size.x / 2) - (self.size.x / 2)   # Center horizontally

	var viewportPos = target_node.get_viewport_rect().position
	var viewportSize = target_node.get_viewport_rect().size

	# Prevent clipping on left side
	if self.position.x < viewportPos.x:
		self.position.x = viewportPos.x
	# Prevent clipping on right side
	elif self.position.x + self.size.x > viewportPos.x + viewportSize.x:
		self.position.x = (viewportPos.x + viewportSize.x) - self.size.x


func _update_visibility(visibility: bool):
	self.visible = visibility

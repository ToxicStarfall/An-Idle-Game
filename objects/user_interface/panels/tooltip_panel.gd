extends Control


@onready var Title = %TitleLabel
@onready var State = %OwnedLabel
@onready var Description = %DescriptionText
@onready var Costs = %CostText
@onready var Tags = %TagsText
@onready var Flair = %FlairText


func _ready() -> void:
	self.hide()  # Hide on start
	Events.request_tooltip.connect( _on_update_tooltip )
	#Events.request_tooltip.connect( _update_visibility )


func _on_update_tooltip(target_node, data, visibility: bool):
	#var global_mouse = get_global_mouse_position()
	#var target_size = target_node.size
	#var target_pos = target_node.get_screen_position()
	#print(global_mouse, " - ", target_pos)
	#if global_mouse.x > target_pos.x and global_mouse.x < target_pos.x + target_size.x \
	#and global_mouse.y > target_pos.y and global_mouse.y < target_pos.y + target_size.y:
		#visibility = true
	#else: visibility = false

	if visibility == true:
		_update_info(data)
		_update_position(target_node)
	_update_visibility(visibility)
	self.size.y = 85


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
	#var target_pos = target_node.get_screen_position()
	#self.position = Vector2(target_pos.x, target_pos.y - self.size.y)
	self.position = target_node.get_screen_position()
	self.position.y -= self.size.y  # Align tooltip bottom above target_node
	self.position.x += (target_node.size.x / 2) - (self.size.x / 2)   # Center horizontally
	pass


func _update_visibility(visibility: bool):
	self.visible = visibility


#extends NinePatchRect
#
##@onready var viewportPos = get_viewport_rect().position
##@onready var viewportSize = get_viewport_rect().size
#
## NOTE subvieport position arent accounted for
#
#
#func set_target(TargetNode):
	#var viewportPos = TargetNode.get_viewport_rect().position
	#var viewportSize = TargetNode.get_viewport_rect().size
	##print(TargetNode.get_viewport())
	##print(TargetNode.get_viewport().get_global_rect())
#
	#var subviewportPos = Vector2()
	#if TargetNode is ResearchNode:
		#subviewportPos = Global.ResearchPanel.position
#
	#var TargetPos = TargetNode.get_global_rect().position
	#var TargetSize = TargetNode.get_global_rect().size
	##print(TargetNode, TargetPos)
#
	#self.position = Vector2( TargetPos.x - (self.size.x - TargetSize.x) / 2, TargetPos.y - self.size.y - 4) + subviewportPos#for subviewports not @ position 0,0
	#self._adjust_position(TargetPos, TargetSize, viewportPos, viewportSize)
#
	#var a = TargetNode.item_id
	#if a:
		#var item = Global.achievments[TargetNode.item_id]
		#self.get_node("%ItemName").text = item.name
		##self.get_node("%ItemCost").text = str(item.cost)
		#self.get_node("%ItemDescription").text = item.desc
	#else:
		#self.get_node("%ItemName").text = TargetNode.data.name
		#self.get_node("%ItemCost").text = str(TargetNode.data.cost)
		#self.get_node("%ItemDescription").text = TargetNode.data.desc
#
	#self.show()
#
#
## adjusts tooltip position to prevent it from being cut-off by the viewport
#func _adjust_position(TargetPos, TargetSize, viewportPos, viewportSize):
	## centers the tooltip vertically to its targetNode
	#var center_vertical = func():
		#self.position.y = TargetPos.y - (self.size.y - TargetSize.y) / 2
#
	## returns true/false if the tooltip does not exceed the left or right side of the viewport
	#var fithorizontal = func():
		#if self.position.x < viewportPos.x or (self.position.x + self.size.x) > (viewportPos.x + viewportSize.x):
			#return false
		#else: return true
#
#
	##print_debug("TargetNode @ " + str(TargetPos))
	## if tooltip exceeds top side of viewport, set y pos to below targetNode
	#if self.position.y < viewportPos.y:
		##print("  - tooltip exceeds the top side of the viewport!")
		#self.position.y = TargetPos.y + TargetSize.y + 4
	## NOTE no logic for bottom side because by default, tooltip shows above target node
#
	#if fithorizontal.call() == false:
		##print("  - tooltip exceeds the left or right side of the viewport!")
		#center_vertical.call()
#
		## if tooltip exceeds left side of viewport, set x pos to the right of targetNode
		#if self.position.x < viewportPos.x:
			#self.position.x = TargetPos.x + TargetSize.x + 4
		## if tooltip exceeds right side of viewport, set x pos to the left of targetNode
		#if (self.position.x + self.size.x) > (viewportPos.x + viewportSize.x):
			#self.position.x = TargetPos.x - self.size.x - 4
#
#
## adjusts tooltip size to prevent it from being cut-off by the viewport IF adjusting position does NOT work
## likely not neccessary
#func _adjust_size():
	#pass

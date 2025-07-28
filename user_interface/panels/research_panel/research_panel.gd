extends PanelContainer


var selected_item

var is_dragging: bool = false
var drag_origin: Vector2
var drag_offset: Vector2
var scroll_pos: Vector2

@onready var ViewportScroll = %ViewportScrollContainer
@onready var TechTree = get_node("%TechTreeContainer")


func _ready() -> void:
	%ViewportMargin.gui_input.connect( _on_tech_tree_gui_input )
	#%SubViewport.size = %ViewportMargin.size #%SubViewportContainer.size
	pass



func _on_tech_tree_gui_input(event: InputEventMouse) -> void:
	if event is InputEventMouseButton:
		#match event.button_index:
			#1:  # Left Click
				#pass
			#2:  # Right Click
				#pass
			#3:  # Middle Click
				#pass
		is_dragging = event.pressed  ## general mousebutton(1,2,or 3)  pressed state
		if is_dragging:
			drag_origin = get_local_mouse_position()
			# Set the current scroll position
			scroll_pos = Vector2( ViewportScroll.scroll_horizontal, ViewportScroll.scroll_vertical )
			#%ViewportMargin.mouse_default_cursor_shape = CURSOR_POINTING_HAND
		#else:
			#%ViewportMargin.mouse_default_cursor_shape = CURSOR_ARROW

	if is_dragging:
		drag_offset = drag_origin - get_local_mouse_position() # offset is difference between new & old pos
		ViewportScroll.scroll_horizontal = scroll_pos.x + drag_offset.x
		ViewportScroll.scroll_vertical = scroll_pos.y + drag_offset.y


func generate_connectors(research_node):
	var TechTree = get_node("%TechTreeContainer")
	var node_data = research_node.item_resource
	#print("updateing connector for node ", node_data.resource_name)

	for requirement in node_data.requirements:
		if requirement is RequirementItem:
			#print(requirement.item.name)
			#print(requirement.item.resource_name)
			#print(requirement.item.get("raw_name"))
			var requirement_node = TechTree.get_node(requirement.item.raw_name)

			#print(requirement_node.position, " - ", research_node.position)
			var connector_scene = preload("res://objects/items/types/research/components/connector.tscn")
			var Connector = connector_scene.instantiate()
			Connector.name = "connector-%s" % [requirement_node.name]
			Connector.points = [
				Vector2(0,0) + research_node.size/2,
				requirement_node.position - research_node.position + (requirement_node.size/2)
			]
			research_node.add_child(Connector)
			# Add an arrow pointing in direction of progression.
			#var arrow = Connector.get_node("TextureRect")
			#arrow.position = (Connector.points[1] - Connector.points[0]) /2 + arrow.size/2
			#arrow.rotation = rotate


func update_connector(research_node):
	var TechTree = get_node("%TechTreeContainer")
	var node_data = research_node.item_resource

	for requirement in node_data.requirements:
		if requirement is RequirementItem:
			var requirement_node = TechTree.get_node(requirement.item.raw_name)
			var Connector = research_node.get_node( "connector-%s" % [requirement_node.name] )
			#TODO Check if requirement node is unlocked to show connectors otherwise dont.
			match requirement_node.item_resource.state:
				pass
			match node_data.state:
				Item.State.OWNED:
					Connector.default_color = Color(1,1,1)
				Item.State.UNLOCKED:
					Connector.default_color = Color(0.5,0.5,0.5)
					Connector.show()
				Item.State.LOCKED:
					Connector.hide()
					pass

extends PanelContainer


#@onready var TechTree = get_node("%TechTreeContainer")
func _ready() -> void:
	pass


func generate_connectors(research_node):
	var TechTree = get_node("%TechTreeContainer")
	var node_data = research_node.item_resource
	#print("updateing connector for node ", node_data.resource_name)

	for requirement in node_data.requirements:
		if requirement is RequirementItem:
			var requirement_node = TechTree.get_node(requirement.item.raw_name)

			#print(requirement_node.position, " - ", research_node.position)
			var connector_scene = preload("res://objects/items/types/research/research_components/connector.tscn")
			var Connector = connector_scene.instantiate()
			Connector.name = "connector-%s" % [requirement_node.name]
			Connector.points = [
				Vector2(0,0) + research_node.size/2,
				requirement_node.position - research_node.position + (requirement_node.size/2)
			]
			research_node.add_child(Connector)
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

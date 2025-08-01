#@tool
extends ItemNode
class_name ResearchNode


signal update_connector( researchNode: ResearchNode )



func _init() -> void:
	#if Engine.is_editor_hint():
		#EditorInterface.get_inspector().property_edited.connect( _on_inspector_property_edited )
		##EditorInterface.get_selection().selection_changed.connect( _on_editor_selection_changed )
	#else:
		super()


func _ready() -> void:
	#if !Engine.is_editor_hint():
		super()
		#item_resource = item_resource.duplicate()  # Missing meta
		item_resource.raw_name = item_resource.resource_path.split("/")[-1].split(".")[0]
		item_resource.resource_name = item_resource.get_script().get_global_name() +":"+ item_resource.raw_name
		item_resource.tags.auto_tag(item_resource)
		GameData.research.set(item_resource.raw_name, item_resource) # Add to dict
		#print("resource_path: ", item_resource.resource_path)
		#print("resource_name: ", item_resource.resource_name)


func _process(_delta: float) -> void:
	#if Engine.is_editor_hint():
		#var viewport2d = EditorInterface.get_editor_viewport_2d()
		#print(viewport2d.gui_is_dragging())
	pass


func _update_state(state: Item.State):
	#if !Engine.is_editor_hint():
		super(state)

		update_connector.emit( self )


func _on_editor_selection_changed():
	#for node in EditorInterface.get_selection().get_transformable_selected_nodes():
		#if node is ResearchNode && item_resource:
			##print(item_resource.get_property_list())
			##item_resource.raw_name = item_resource.resource_path.split("/")[-1].split(".")[0]
			##print(item_resource.raw_name)
			##if !item_resource.raw_name:
				##item_resource.raw_name = item_resource.resource_path.split("/")[-1].split(".")[0]
			##update_connector2()
			pass

func _on_inspector_property_edited(property: String) -> void:
	# Runs on every instance fpr some reason
	#var get_info = func():
		#if item_resource:
			#var raw_name = item_resource.resource_path.split("/")[-1].split(".")[0]
			#print(raw_name)
			#self.name = raw_name
	##print(property)
	#if property == "item_resource":  # Edited obj filter (ItemNode and children class only)
		#var edit_obj = EditorInterface.get_inspector().get_edited_object()
		#if edit_obj == self:
			#print(item_resource)
			#print("hi")
		#get_info.call_deferred()
	pass

	#match property:
		#"position":  # This DOES NOT trigger from dragging nodes in the editor
			#update_connector2()
			#pass


func generate_connectors():
	var TechTree = self.get_parent()
	var node_data = self.item_resource
	#print("updateing connector for node ", node_data.resource_name)

	for requirement in node_data.requirements:
		if requirement is RequirementItem:
			#var requirement_node = TechTree.get_node_or_null(requirement.item.raw_name)
			var requirement_node = TechTree.find_child(requirement.item.raw_name, false)
			if requirement_node:
				var connector_scene = preload("res://objects/items/types/research/components/connector.tscn")
				var Connector = connector_scene.instantiate()
				Connector.name = "connector-%s" % [requirement_node.name]
				Connector.points = [
					Vector2(0,0) + self.size/2,
					requirement_node.position - self.position + (requirement_node.size/2)
				]
				self.add_child(Connector)

				# Add an arrow pointing in direction of progression.
				#var arrow = Connector.get_node("TextureRect")
				#arrow.position = (Connector.points[1] - Connector.points[0]) /2 + arrow.size/2
				#arrow.rotation = rotate


func update_connector2():
	print("updated connector")
	var TechTree = self.get_parent()
	var node_data = self.item_resource

	for requirement in node_data.requirements:
		if requirement is RequirementItem:
			#var requirement_node = TechTree.get_node_or_null(requirement.item.raw_name)
			var requirement_node = TechTree.find_child(requirement.item.raw_name, false)
			var Connector = self.get_node( "connector-%s" % [requirement_node.name] )
			if !requirement_node:  continue  # Ignore connector if x node does not yet exist
			if !Connector:
				generate_connectors()

			match node_data.state:
				Item.State.OWNED:
					Connector.default_color = Color(1,1,1)
				Item.State.UNLOCKED:
					Connector.default_color = Color(0.5,0.5,0.5)
					Connector.show()
				Item.State.LOCKED:
					Connector.hide()
					pass

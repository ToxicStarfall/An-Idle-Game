extends Node


enum Currency { WeaponsPOWER }
#var Features = {
	#MEDITATION
#}

#region - - - VARIABLES - - - - #
@onready var UpgradesPanel = $/root/Main/%UpgradesPanel
@onready var ResearchPanel = $/root/Main/%ResearchPanel
@onready var GeneratorsPanel = $/root/Main/%GeneratorsPanel

#@onready var timer = $/root/Main/%UpdateTimer#= get_tree().create_timer(1/20)

#var game_data = GameData.new()

#endregion


#region - - - SIGNALS - - - - - #

#endregion


func _ready() -> void:
	## Connect Signals
	Events.user_interface_loaded.connect( _initialize_game )
	Events.game_saved.connect( save_game_data )
	Events.game_loaded.connect( load_game_data )
	Events.function_unlocked.connect( _on_function_unlocked )
	Events.function_highlighted.connect( _on_function_highlighted )


#region - - - HELPER FUNCTIONS - - - - #
func get_property(property_name):
		var property = GameData.get(property_name)
		if property == null:
			push_error("cannot find a property of name \"%s\"" % [property_name])
			return property
		else:
			return property


func get_item(item_key: String, item_dict_name):
	var item = GameData.get(item_dict_name).get(item_key)
	if item == null:
		push_error("cannot find a item of name \"%s\"" % [item_key])
		return null
	else:
		return item
#endregion


#region
func _on_function_unlocked(node_name):
	get_tree().root.get_node("Main/%" + node_name).show()


## Creates a highlight guide on the specified node which stops after the stop_signal is emitted
func _on_function_highlighted(node_name, stop_signal="pressed"):
	var active = [true]
	var node = get_tree().root.get_node("Main/%" + node_name)
	#node.get_node("Button").pressed.connect( func():
	var tween = get_tree().create_tween()
	var disabled = func():
		active[0] = false
	var check_disabled = func():
		if active[0] == false:
			tween.kill()
			node.get_node("Button").disconnect(stop_signal, disabled)
			GameData.ui_hint[node_name] = false
	node.get_node("Button").connect(stop_signal, disabled)
	#node.get_node("Button").connect("pressed", disable_triggered)
	tween.set_loops()
	tween.tween_property(node, "modulate", Color(1,1,1, 0.5), 0.5).set_delay(0.1)
	tween.tween_property(node, "modulate", Color(1,1,1, 1), 0.5)
	tween.tween_callback( check_disabled )
	#await tween.loop_finished

#endregion


#region - - - INITIALIZATION - - - - #
## Loads game resources & saves.
func _initialize_game():
	print("Loading game resources...")
	await Game.load_game_data()         # Loads save (loads edited resources)
	await _initialize_game_resources()  # Loads default resources
	#await Game.save_game_data()


func _initialize_game_resources():
	await _initialize_upgrades()
	#await _initialize_research()
	await _initialize_research_tree()
	await _initialize_generators()
	await _initialize_scripted_events()
	print("Finished loading resources.\n")
	GameData.initialize_values()
	pass


func _initialize_upgrades():
	const upgrades_folder_path = "res://objects/items/types/upgrades/upgrade_items/"
	var upgrades_folder = ResourceLoader.list_directory( upgrades_folder_path )
	if upgrades_folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [upgrades_folder_path])
	else:
		for file in upgrades_folder:
			var item = ResourceLoader.load(upgrades_folder_path + file).duplicate()
			var raw_name = file.split(".")[0]
			item.raw_name = raw_name
			item.resource_name = "upgrade:%s" % [raw_name]
			item.tags.generate(item)
			GameData.upgrades.set(raw_name, item)
			#print(item.resource_name)

			# Adds upgrade nodes to FlowContainer
			var item_node = preload("res://objects/items/types/upgrades/upgrade_components/upgrade_node.tscn").instantiate()
			item_node.name = raw_name
			item_node.item_resource = item  # set node data
			UpgradesPanel.get_node("%ItemContainer").add_child( item_node )
		print("Upgrades loaded.")


func _initialize_research():
	const research_folder_path = "res://objects/items/types/research/items/"
	var research_folder = ResourceLoader.list_directory( research_folder_path )

	if research_folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [research_folder_path])
	else:
		for file in research_folder:
			var item = ResourceLoader.load(research_folder_path + file).duplicate()
			var raw_name = file.split(".")[0]
			item.set_meta(name, "Research:%s" % [file.split(".")[0]])
			# if file_name.ends_with(".remap"):  # TEMPROARY FIX FOR WEB EXPORT
			# 	file_name = file_name.replace(".remap", "")
			item.raw_name = raw_name
			item.resource_name = "research:%s" % [raw_name]
			#GameData.research.set(raw_name, item)
			GameData.save_data.research.set(raw_name, item)
			#print(item.resource_name)

			#var item_node = preload("res://objects/items/types/research/research_components/research_node.tscn").instantiate()
			#item_node.item_resource = item
			item.tags.generate(item)
			#ResearchPanel.get_node("%TechTreeContainer").add_child( item_node )
		print("Research items loaded.")
		_initialize_research_tree()
	pass


func _initialize_research_tree():
	#const research_node_scene_path = "res://objects/items/types/research/research_components/research_node.tscn"
	var TechTree = ResearchPanel.get_node("%TechTreeContainer")

	for research_node in TechTree.get_children():
		#print(research_node.item_resource.raw_name)
		#print(research_node.item_resource.resource_path)
			#var item = GameData.research.get(reference_key)

			#var research_node = preload(research_node_scene_path).instantiate()
			#research_node.name = reference_key
			#research_node.item_resource = item
		research_node.update_connector.connect(ResearchPanel.update_connector)
			#reserach_node.state_updated

			#research_node.position = placeholder_node.position
			#TechTree.add_child(research_node)        # Add research node
		#else:
			#print("Cannot find reference key for research node: \"%s\"" % [reference_key])
		#pass

		ResearchPanel.generate_connectors(research_node)
		research_node.update_connector.emit(research_node)
	print("Research tree created.")


func _initialize_generators():
	const generators_folder_path = "res://objects/items/types/generators/items/"
	var generators_folder = ResourceLoader.list_directory( generators_folder_path )

	if generators_folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [generators_folder_path])
	else:
		for file in generators_folder:
			var item = ResourceLoader.load( generators_folder_path + file).duplicate()
			var raw_name = file.split(".")[0]
			item.raw_name = raw_name
			item.resource_name = "generator:%s" % [raw_name]
			item.tags.generate(item)
			GameData.generators.set(raw_name, item)
			#print(item.resource_name)

			#var item_node = preload("res://objects/items/types/generators/generator_node.tscn").instantiate()
			#item_node.name = raw_name
			#item_node.item_resource = item  # set node data
			#GeneratorsPanel.get_node("%ItemContainer").add_child( item_node )
		print("Generators loaded.")
	pass


func _initialize_scripted_events():
	const folder_path = "res://objects/items/types/scripted_events/items/"
	var folder = ResourceLoader.list_directory( folder_path )

	if folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [folder_path])
	else:
		for file in folder:
			var item = ResourceLoader.load( folder_path + file)#duplicate()
			var raw_name = file.split(".")[0]
			item.raw_name = raw_name
			item.resource_name = "scripted_event:%s" % [raw_name]
			item.tags.generate(item)
			GameData.scripted_events.set(raw_name, item)
			#print(item.resource_name)
		print("Scripted events loaded.")
	pass

#endregion


#region - - - SAVE FILE - - - - #
func save_game_data():
	# GameData.save_data contains all updates and can be saved directly by ResourceLoader.
	var save_data = GameData.save_data

	for i in GameData.get_property_list():
		if i.usage == 4102:
			var property = i.name
			var value = GameData.get(property)
			#print(property, value)
			if i.type is not Dictionary:
				save_data.set(property, value)
			else: #if i.type == TYPE_DICTIONARY:
				var dict_name = property
				var dict = GameData.get(property)
				var dict_value_class_name = dict.get_typed_value_script()
				#print(dict_value_class_name)
				# Filter dictionaries which define [Item] as a type for its values (stores Item).
				if dict_value_class_name and dict_value_class_name.get_global_name() == "Item":
					#save_data.set(dict_name, dict)
					pass
				else:  # Normal Dicts
					save_data.set(dict_name, dict)
	_save_items()
	ResourceSaver.save(save_data, "user://save_file.tres")


func load_game_data():
	var save_data = ResourceLoader.exists("user://save_file.tres")

	# If there IS a file, load data over.
	if save_data:
		save_data = ResourceLoader.load("user://save_file.tres")
		_load_items(save_data) # Load items first. Settings stats automatically updates them afterwards.
		_load_data_dicts(save_data)
		for i in save_data.get_property_list():
			if i.usage == 4102:
				var property = i.name
				var value = save_data.get(property)
				#print(property, value)
				if value is not Dictionary:
					GameData.set(property, value)  # Triggers setters to update
					GameData.update_items(property)  # Update items with linked tags when loading data
				else:
					#GameData.get(property).assign(value)
					#GameData.set(property, value)
					#print( GameData.get(property) )
					pass
	# If there is NO save file, make a new file.
	elif !save_data:
		GameData.save_data = SaveFile.new()
		print("new_save_created")


func _save_items():
	for dict_name in ["upgrades", "research", "generators"]:
		var saved_dict = {}
		var dict = GameData.get(dict_name)
		#print(dict)

		# Convert [dict] into {key: Item.State} format or similar.
		for item_key in dict:
			var item = dict.get(item_key)
			match item.get_script().get_global_name():
				"Generator":
					pass
				# [Research] and [Upgrades] are saved with [Item.State]
				"Research", "Upgrade":
					saved_dict.set(item_key, item.state)

		#print(saved_dict)
		GameData.save_data.set(dict_name, saved_dict)
		#print(GameData.save_data.get(dict_name))


func _load_items(save_data): # save data instance required or causes update issues
	#var save_data = GameData.save_data
	#for dict_name in ["upgrades", "research", "generators"]:  # WARNING loading upgrades is broken.
	for dict_name in ["research", "generators"]:
		const Type = Item.Type
		var dict = save_data.get(dict_name)
		#print(dict)

		for item_key in dict:
			var item = GameData.get(dict_name).get(item_key)
			var saved_item_state = dict.get(item_key)
			# Access each item and update its state individually
			match item.type:
				Type.GENERATOR:
					pass
				Type.RESEARCH, Type.UPGRADE:
					item.set_state(saved_item_state)
					pass


func _load_data_dicts(save_data):  # Loads dicts for feature unlock flags
	for dict_name in ["ui_hint"]:
		#const Type = Item.Type
		var dict = save_data.get(dict_name)

		#print(dict)
		print(GameData.get(dict_name))
		GameData.set(dict_name, dict)
		#for i in GameData.get(dict_name):
			#GameData.get(dict_name).set(i, dict[i])
		#GameData.get(dict_name).set(dict_name, dict)
		print(GameData.get(dict_name))
#endregion
#
#

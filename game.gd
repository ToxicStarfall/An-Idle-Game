extends Node


enum Currency { WeaponsPOWER }

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
	Events.user_interface_loaded.connect( _initialize_game )
	Events.game_saved.connect( save_game_data )
	Events.game_loaded.connect( load_game_data )
	Events.function_unlocked.connect( _on_function_unlocked )


## Loads resources & saves.
func _initialize_game():
	print("Loading game resources...")
	await _initialize_game_resources()  # Loads default resources
	await Game.load_game_data()         # Loads save (loads edited resources)
	#await Game.save_game_data()



#region - - - HELPER FUNCTIONS - - - - #
func get_property( property_name ):
	#if property_name.contains("."):
		#return _get_resource(property_name)
	#else:
		var property = GameData.get(property_name)
		if property == null:
			push_error("cannot find a property of name \"%s\"" % [property_name])
			return property
		else:
			return property


# returns Resource.value  if property is a Resource
#func get_resource( fullname ):
	#fullname = fullname.split(".")
	#print(fullname)
	#var base_name = fullname[0]
	#var property_name = fullname[1]
	#var property = game_data.get(base_name)
	#print(property)
	#property = property.get(property_name)
	#return property


func get_item( item_name, type ):
	var item = GameData.get(type).get(item_name)
	#item = game_data.upgrades.get( item_name ) # .get() returns value since upgrades is a Dictionary

	if item == null:
		push_error("cannot find a item of name \"%s\"" % [item_name])
		return null
	else:
		return item
#endregion


#region
func _on_function_unlocked(node_name):
	get_tree().root.get_node("Main/%" + node_name).show()
	pass
#endregion


#region - - - INITIALIZATION - - - - #

func _initialize_game_resources():
	await _initialize_upgrades()
	#await _initialize_research()
	await _initialize_research_tree()
	await _initialize_generators()
	print("Finished loading resources.\n")
	GameData.initilize_values()
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
			item.tags.auto_tag(item)
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
			item.tags.auto_tag(item)
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
		#var reference_key = placeholder_node.name
		#if GameData.research.has(reference_key) && placeholder_node is ResearchPlaceholder:
			#var item = GameData.research.get(reference_key)

			#var research_node = preload(research_node_scene_path).instantiate()
			#research_node.name = reference_key
			#research_node.item_resource = item
			research_node.update_connector.connect(ResearchPanel.update_connector)
			#reserach_node.update_state

			#research_node.position = placeholder_node.position
			#TechTree.remove_child(placeholder_node)  # Remove placeholder
			#placeholder_node.queue_free()            # Delete placholder
			#TechTree.add_child(research_node)        # Add research node

			ResearchPanel.generate_connectors(research_node)
		#else:
			#print("Cannot find reference key for research node: \"%s\"" % [reference_key])
		#pass
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
			item.tags.auto_tag(item)
			GameData.generators.set(raw_name, item)
			#print(item.resource_name)

			#var item_node = preload("res://objects/items/types/generators/generator_node.tscn").instantiate()
			#item_node.name = raw_name
			#item_node.item_resource = item  # set node data
			#GeneratorsPanel.get_node("%ItemContainer").add_child( item_node )
		print("Generators loaded.")
	pass

#endregion


#region - - - SAVE FILE - - - - #

#func save_GameData():
	#var save_file = ConfigFile.new()
	#for property in GameData.get_property_list():
		#match property.usage:
			#135168:  # 135168( dictionary/array )
				#print( "%s - %s" % [property.name, get_property(property.name)] )
				#for item in get_property(property.name):
					#print(item)
					#save_file.set_value(property.name, item, get_property(property.name)[item])
#
			#4096:  #4096( normal variable types )
				#save_file.set_value("", property.name, Game.get_property(property.name))
				## print(property)
#
	#var err = save_file.save("user://save_data.cfg")
	#if err != OK:  push_error("There was an error while saving the save file.")
	#pass


func save_game_data():
	# GameData.save_data contains all updates and can be saved directly by ResourceLoader.
	var save_data = GameData.save_data
	#print(GameData.research)
	#for i in save_data.get_property_list():#GameData.get_property_list():
		#if i.usage == 4102:
			#var key = i.name
			#var property = save_data.get(key)
			#save_data.set(key, property)
			#if property is Dictionary:
				#print("DICT")
				#for item in property:  # Loop dictionary
					#print(property[item])
					#property.item
					#pass
				#save_data.set(key, property)
				#pass

	for i in GameData.get_property_list():
		if i.type == TYPE_DICTIONARY:
			var dict_name = i.name
			var dict = GameData.get(dict_name)
			#print(dict.get_typed_value_script())
			var dict_value_class_name = dict.get_typed_value_script()
			# Filter Dictionary which defines [Item] as a type for its values (stores Item).
			if dict_value_class_name and dict_value_class_name.get_global_name() == "Item":
				save_data.set(dict_name, dict)
				#print(dict)
	_save_items()
	#print(GameData.research)
	#save_data.research = GameData.research
	ResourceSaver.save(save_data, "user://save_file.tres")
	#print(ResourceLoader.load("user://save_file.tres").research)
	pass

#func load_GameData():
	#var disabled = ["weaponsPC","baseWeaponsPC","weaponsPS","baseWeaponsPS"]
	#var save_file = ConfigFile.new()
	#var err = save_file.load("user://save_data.cfg")
	#if err != OK:  push_error("There was an error while loading the save file.")
#
	#for section in save_file.get_sections():  # for each section in save file
		##print(section)
		#for key in save_file.get_section_keys(section):  # for each entry in save file
			##print(key)
			#var key_value = save_file.get_value(section, key)
#
			## Load non-item save entries
			#if section == "":  # if unspecified section
				#if disabled.has(key):  # if "key" is marked as disabled
					#continue  # then skip
				#GameData.set(key, key_value)
#
			## Load item-based save entries here
			#else:
				##print(GameData.get(section)[key])
				#GameData.get(section)[key] = key_value
				#pass


func load_game_data():
	var save_data = ResourceLoader.exists("user://save_file.tres")

	# If there IS a file, load data over.
	if save_data:
		save_data = ResourceLoader.load("user://save_file.tres")
		_load_items(save_data)
		for i in save_data.get_property_list():
			if i.usage == 4102:#4102:
				var key = i.name
				var property = save_data.get(key)
				#print(key)
				if property is not Dictionary:
					#GeameData.save_data.set(key, property)  # Triggers setters to update
					GameData.set(key, property)  # Triggers setters to update
					GameData.update_items(key)  # Update items with linked tags when loading data
				else:
					#print(property)
					#GameData.get(key).assign(property)
					#GameData.set(key, property)
					#print( GameData.get(key) )
		#GameData.save_data = save_data
		#GameData._set_item()
					#_load_item_dict(key, property)  # Handles loading item dictionaries
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


func _load_item_dict(dict_name, dict):
	#print("Loading Items")
		var save_data = GameData.save_data

	#for dict_name in ["upgrades", "research", "generators"]:

		const Type = Item.Type
		#var dict = save_data.get(dict_name)
		#print(dict_name)
		print(dict)
		#print(GameData.get(dict_name))

		for item_key in dict:
			var item = GameData.get(dict_name).get(item_key)
			var item_state = dict.get(item_key)
			print(item.raw_name, " state - ", item_state)
			# Access each item and update its state individually
			match item.type:
				Type.GENERATOR:
					pass
				Type.RESEARCH, Type.UPGRADE:
					#item.state = item_state
					item.set_state(item.state)
					pass

		#print(saved_dict)
		#GameData.save_data.set(dict_name, saved_dict)


func _load_items(save_data):
	#var save_data = GameData.save_data

	for dict_name in ["upgrades", "research", "generators"]:
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
#endregion
#
#

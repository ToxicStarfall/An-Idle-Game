extends Node


@onready var UpgradesPanel = $/root/Main/%UpgradesPanel
@onready var ResearchPanel = $/root/Main/%ResearchPanel


var game_data = GameData.new()

enum Currencies { WeaponsPOWER }

#region - - - VARIABLES - - - - #
@onready var timer = $/root/Main/%UpdateTimer#= get_tree().create_timer(1/20)

#endregion

#region - - - SIGNALS - - - - - #
signal update
signal update_tooltip

#endregion


func _ready() -> void:
	#add_resource("weaponPower", 1)
	print("Loading game resources...")
	await _initialize_game_resources()
	#await Game.load_game_data()
	#Game.save_game_data()
	#timer = get_tree().create_timer(1/20)
	timer.timeout.connect( func(): update.emit() )
	timer.start()

	update.connect(
		func():
			#print("update frame")
			pass
	)

	#game_data.a()
	pass


func _process(_delta: float) -> void:
	#update.emit()
	pass


# overude _get() to make custom version of get()
func _get(property: StringName) -> Variant:
	return


func find_property(property_name):
	#if property_name.contains("."):
		#return _get_resource(property_name)
	#else:
		var property = game_data.get(property_name)
		if property == null:
			push_error("cannot find a property of name \"%s\"" % [property_name])
			return property
		else:
			return property


func find_item(item_name, type):
	var item
	item = game_data.upgrades.get( item_name ) # .get() returns value since upgrades is a Dictionary

	if item == null:
		push_error("cannot find a item of name \"%s\"" % [item_name])
		return null
	else:
		return item


# returns Resource.value  if property is a Resource
func get_resource(fullname):
	fullname = fullname.split(".")
	print(fullname)
	var base_name = fullname[0]
	var property_name = fullname[1]
	var property = game_data.get(base_name)
	print(property)
	property = property.get(property_name)
	return property


func add_resource(resource_type:String, value):
	var resource = find_property(resource_type)
	#print(resource_type,": ",resource," ",value)
	resource += value
	#print(resource_type,": ",resource)
	game_data.set(resource_type, resource)
	#print(find_property(resource_type))
	_update_items( resource_type ) # swap vars with resource to store extra info like value & tagname
	pass


func subtract_resource(resource_type:String, value:int):
	var resource = find_property(resource_type)
	resource -= value
	game_data.set(resource_type, resource)
	pass


func _update_items(filter_tag):
	filter_tag = filter_tag.to_upper()
	#print("Updating items with tag: ", filter_tag)
	for j in [game_data.upgrades, game_data.research]:
		for i in j: #game_data.upgrades:
			var item = j[i] #game_data.upgrades[i]
			#print(item.name)

			var valid_filter
			#if filter_tag.contains("."):
				#filter_tag = filter_tag.insert(8, ".")
				#filter_tag = filter_tag.replace(".", "")
				#filter_tag = "".join(filter_tag.split("."))
				#print("removed period")
				#pass
			const Tags = ItemTags.Tags
			var tag = Tags.find_key(Tags.get(filter_tag))
			if item.tags.internal_tags.has( tag ):#item.tags.Tags[filter_tag] ):
				#print("matching item: ", item.name)
				valid_filter = true

			if item.state == item.State.LOCKED and valid_filter:#item.tags.has(filter_tag):
				item.unlock()



#region - - - INITIALIZATION - - - - #

func _initialize_game_resources():
	await _initialize_upgrades()
	await _initialize_research()
	await _initialize_research_tree()
	print("Finished loading resources.\n")
	pass


func _initialize_upgrades():
	var upgrades_folder_path = "res://objects/items/types/upgrades/upgrade_items/"#"res://objects/items/upgrades/upgrade_items/"
	var upgrades_folder = DirAccess.open( upgrades_folder_path )
	if upgrades_folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [upgrades_folder_path])
		DirAccess.get_open_error()
	else:
		var upgrade_files = upgrades_folder.get_files()
		for file_name in upgrade_files:
			var item = load("%s/%s" % [upgrades_folder_path, file_name])
			var raw_name = file_name.split(".")[0]
			item.raw_name = raw_name
			item.resource_name = "upgrade:%s" % [raw_name]
			item.tags.auto_tag(item)
			game_data.upgrades[ raw_name ] = item
			#print(item.resource_name)

			# Adds upgrade nodes to FlowContainer
			var item_node = preload("res://objects/items/types/upgrades/upgrade_components/upgrade_node.tscn").instantiate()
			item_node.name = raw_name
			item_node.item_resource = item  # set node data
			UpgradesPanel.get_node("%ItemContainer").add_child( item_node )
		print("Upgrades loaded.")


func _initialize_research():
	const research_folder_path = "res://objects/items/types/research/research_items/"

	var research_folder = DirAccess.open( research_folder_path )
	if research_folder == null:
		push_error("An error occured while accessing folder \"%s\"" % [research_folder_path])
		DirAccess.get_open_error()
	else:
		var research_files = research_folder.get_files()
		for file_name in research_files:
			var item = load("%s/%s" % [research_folder_path, file_name])
			var raw_name = file_name.split(".")[0]
			item.raw_name = raw_name
			item.resource_name = "research:%s" % [raw_name]
			game_data.research[ raw_name ] = item
			#print(item.resource_name)

			#var item_node = preload("res://objects/items/types/research/research_components/research_node.tscn").instantiate()
			#item_node.item_resource = item
			item.tags.auto_tag(item)
			#ResearchPanel.get_node("%TechTreeContainer").add_child( item_node )
		print("Research items loaded.")
		#_initialize_research_tree()
	pass


func _initialize_research_tree():
	const research_node_scene_path = "res://objects/items/types/research/research_components/research_node.tscn"
	var TechTree = ResearchPanel.get_node("%TechTreeContainer")

	for placeholder_node in TechTree.get_children():
		var reference_key = placeholder_node.name
		if game_data.research.has(reference_key) && placeholder_node is ResearchPlaceholder:
			var item = game_data.research.get(reference_key)

			var research_node = preload(research_node_scene_path).instantiate()
			research_node.name = reference_key
			research_node.item_resource = item
			research_node.update_connector.connect(ResearchPanel.update_connector)
			#reserach_node.update_state

			research_node.position = placeholder_node.position
			TechTree.remove_child(placeholder_node)  # Remove placeholder
			placeholder_node.queue_free()            # Delete placholder
			TechTree.add_child(research_node)        # Add research node

			ResearchPanel.generate_connectors(research_node)
		else:
			print("Cannot find reference key for research node: \"%s\"" % [reference_key])
	print("Research tree created.")
	pass
#endregion


#region - - - SAVE FILE - - - - #

#func save_game_data():
	#var save_file = ConfigFile.new()
	#for property in game_data.get_property_list():
		#match property.usage:
			#135168:  # 135168( dictionary/array )
				#print( "%s - %s" % [property.name, find_property(property.name)] )
				#for item in find_property(property.name):
					#print(item)
					#save_file.set_value(property.name, item, find_property(property.name)[item])
#
			#4096:  #4096( normal variable types )
				#save_file.set_value("", property.name, Game.find_property(property.name))
				## print(property)
#
	#var err = save_file.save("user://save_data.cfg")
	#if err != OK:  push_error("There was an error while saving the save file.")
	#pass


func save_game_data():
	ResourceSaver.save(game_data, "user://game_data.tres")
	pass

#func load_game_data():
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
				#game_data.set(key, key_value)
#
			## Load item-based save entries here
			#else:
				##print(game_data.get(section)[key])
				#game_data.get(section)[key] = key_value
				#pass

func load_game_data():
	var save = ResourceLoader.load("user://game_data.tres")
	game_data = save
	pass

#endregion
#
#

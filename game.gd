extends Node


var game_data = GameData.new()

enum Currencies { WeaponsPOWER }

#region - - - VARIABLES - - - - #
@onready var timer = $/root/Main/%UpdateTimer#= get_tree().create_timer(1/20)

#endregion

#region - - - SIGNALS - - - - - #
signal update

#endregion


func _ready() -> void:
	#print(game_data.weapons.PC)
	#print(game_data.weapons.get("Power"))
	#find_property("weapons.Power")

	#ResourceLoader.load("user://game_data.tres")
	#print(game_data.baseWeaponsPC)
	#game_data.baseWeaponsPC += 12
	#print(game_data.baseWeaponsPC)
	var s = ResourceSaver.save(game_data, "user://game_data.tres")

	#add_resource("weaponPower", 1)
	print("Loading game resources...")
	await initialize_game_resources()
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


func find_item(item_name):
	var item
	item = game_data.upgrades.get( item_name ) # .get() returns value since upgrades is a Dictionary

	if item == null:
		push_error("cannot find a item of name \"%s\"" % [item_name])
		return null
	else:
		return item


# returns Resource.value  if property is a Resource
func _get_resource(fullname):
	fullname = fullname.split(".")
	print(fullname)
	var base_name = fullname[0]
	var property_name = fullname[1]
	var property = game_data.get(base_name)
	print(property)
	property = property.get(property_name)
	return property


func add_resource(resource_type:String, value):
	var resource = find_property(resource_type)#game_data.get_property_list().find(resource_type)
	resource += value
	game_data.set(resource_type, resource)
	game_data.update_items.emit( resource_type ) # swap vars with resource to store extra info like value & tagname
	pass


func remove_resource(resource_type:String, value:int):
	var resource = find_property(resource_type)
	resource -= value
	game_data.set(resource_type, resource)
	pass



#region - - - Initialization - - - - #
func initialize_game_resources():
	await _initialize_upgrades()
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
			item.resource_name = file_name
			game_data.upgrades[ item.name ] = item

			# Adds upgrade nodes to FlowContainer
			var item_node = UpgradeNode.new()
			item_node.item_resource = item
			item_node.custom_minimum_size = Vector2(80,80)
			$/root/Main/%UpgradesPanel/%ItemContainer.add_child( item_node )
		print("Upgrades loaded.")
#endregion


#region - - - Save File - - - - #
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


func load_game_data():
	var disabled = ["weaponsPC","baseWeaponsPC","weaponsPS","baseWeaponsPS"]
	var save_file = ConfigFile.new()
	var err = save_file.load("user://save_data.cfg")
	if err != OK:  push_error("There was an error while loading the save file.")

	for section in save_file.get_sections():  # for each section in save file
		#print(section)
		for key in save_file.get_section_keys(section):  # for each entry in save file
			#print(key)
			var key_value = save_file.get_value(section, key)

			# Load non-item save entries
			if section == "":  # if unspecified section
				if disabled.has(key):  # if "key" is marked as disabled
					continue  # then skip
				game_data.set(key, key_value)

			# Load item-based save entries here
			else:
				#print(game_data.get(section)[key])
				game_data.get(section)[key] = key_value
				pass
#endregion
#
#

extends Node




func _ready() -> void:
	#add_resource("weaponPower", 1)
	#print( find_property("weaponPower") )
	#Game.load_game_data()
	#Game.save_game_data()
	#add_resource("baseWeaponsPC", 1)
	pass


func _process(delta: float) -> void:
	pass



func find_property(property_name):
	var property
	for obj in GameData.get_property_list():
		# usage property says what kind of property it is (in this case, it means a "user defined" property)
		if obj.usage == 135168 or obj.usage == 4096:
			property = GameData.get(property_name)

	if property == null:
		print_debug("cannot find a property of name \"%s\"" % [property_name])
		#return property
	else:
		return property
	pass


func add_resource(resource_type:String, value:int):
	var resource = find_property(resource_type)#GameData.get_property_list().find(resource_type)
	resource += value
	GameData.set(resource_type, resource)
	pass


func remove_resource(resource_type:String, value:int):
	var resource = find_property(resource_type)
	resource -= value
	GameData.set(resource_type, resource)
	pass



#region - - Save File - - -
#
func save_game_data():
	var save_file = ConfigFile.new()
	for property in GameData.get_property_list():
		match property.usage:
			135168, 4096:  # 135168( dictionary/array )  4096( normal variable types )
				save_file.set_value("", property.name, Game.find_property(property.name))
				print(property)

	var err = save_file.save("user://save_data.cfg")
	if err != OK:  print_debug("There was an error while saving the save file.")
	pass


func load_game_data():
	var disabled = ["weaponsPC","baseWeaponsPC","weaponsPS","baseWeaponsPS"]
	var save_file = ConfigFile.new()
	var err = save_file.load("user://save_data.cfg")
	if err != OK:  print_debug("There was an error while loading the save file.")

	for key in save_file.get_section_keys(""):
		if disabled.has(key):  continue
		var key_value = save_file.get_value("", key)
		GameData.set(key, key_value)
	pass

#endregion
#
#

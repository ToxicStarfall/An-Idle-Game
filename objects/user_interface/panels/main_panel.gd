extends Control



func _ready() -> void:
	%UserInterface.update_counters.connect( _update_counter )
	pass



func _update_counter():
	%WeaponPowerLabel.text = "%s weapon power" % [Game.find_property("weaponPower")]#[GameData.weaponPower]
	#%ResearchProgress.value = # update research progress value
	pass


func _update_labels():
	pass


func _on_button_pressed() -> void:
	Game.add_resource( "weaponPower", Game.find_property("weaponsPC"))

	#print("baseWeaponPC: ", Game.find_property("baseWeaponsPC") )
	#print(Game.game_data.weaponPower)
	pass

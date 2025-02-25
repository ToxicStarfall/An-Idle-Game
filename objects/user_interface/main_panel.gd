extends Control



func _ready() -> void:
	%UserInterface.update_counters.connect( _update_counter )
	pass



func _update_counter():
	%WeaponPowerLabel.text = "%s weapon power" % [GameData.weaponPower]
	pass


func _update_labels():
	pass


func _on_button_pressed() -> void:
	Game.add_resource( "weaponPower", GameData.weaponsPC )
	#print(GameData.weaponPower)
	pass

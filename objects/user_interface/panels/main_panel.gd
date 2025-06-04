extends Control



func _ready() -> void:
	%UserInterface.update_counters.connect( _update_counter )

	%ResearchProgress/Button.pressed.connect( _toggle_research_panel )
	%ThoughtButton.pressed.connect(_on_thought_button_pressed)
	%ThoughtProgressBar.value_changed.connect(_update_thought_progress_bar)
	pass


func _update_counter():
	%WeaponPowerLabel.text = "%s weapon power" % [Game.find_property("weaponPower")]#[GameData.weaponPower]
	#%ResearchProgress.value = # update research progress value
	pass


func _update_labels():
	pass


#func _on_button_pressed() -> void:
	#Game.add_resource( "weaponPower", Game.find_property("weaponsPC"))
	#print("baseWeaponPC: ", Game.find_property("baseWeaponsPC") )
	#print(Game.game_data.weaponPower)
	#pass

func _on_thought_button_pressed():
	Game.add_resource("thoughtProgress", Game.find_property("thoughtFillAmount"))
	%ThoughtProgressBar.value = Game.find_property("thoughtProgress") * 100
	print( Game.find_property("thoughtProgress") )
	pass
func _update_thought_progress_bar(value):
	pass


func _toggle_research_panel():
	%ResearchPanel.visible = !%ResearchPanel.visible

extends Panel


@onready var EngineeringPanel = %EngineeringPanel
#@onready var GeneratorsPanel = %GeneratorsPanel


#var selected_node: UpgradeNode  # replace with engineering specific upgrade type item

#var generator_action_multiplier: int = 1
#var generator_allow_sell: bool = true


func _ready() -> void:
	#Game.upgrade_selecetd.connect( _update_engineering_panel )
	pass


#func _update_engineering_panel(selected_item):
	#EngineeringPanel.get_node("%ItemContainer").add_child( selected_item.duplicate() )
	#pass

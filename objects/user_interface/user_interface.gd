extends Control


#var current_scene: Control
#var current_panel: Control

var scenes = []
#var panels = [ %ResearchPanelContainer, %UpgradesPanelContainer ]


#signal update_counters

func _ready() -> void:
	pass


func _process(_delta: float) -> void:
	#update_counters.emit()
	pass

extends Control


#var current_scene: Control
#var current_panel: Control

var scenes = []
#var panels = [ %ResearchPanelContainer, %UpgradesPanelContainer ]


signal update_counters
signal update_labels
signal update_content


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	update_counters.emit()
	pass

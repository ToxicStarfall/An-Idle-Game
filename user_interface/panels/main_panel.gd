extends Control


var current_panel: Control
#var panels = [ %ResearchPanelContainer, %UpgradesPanelContainer ]


func _ready() -> void:
	%ResearchProgress/Button.pressed.connect( _toggle_research_panel )
	pass


# Opens research panel
func _toggle_research_panel():
	%ResearchPanel.visible = !%ResearchPanel.visible


func _on_tab_bar_tab_changed(tab: int) -> void:
	%TabContainer.current_tab = tab
	pass # Replace with function body.

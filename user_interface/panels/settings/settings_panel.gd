extends PanelContainer


var changes = {
	"number_display": 3,
}

@onready var a = preload("res://user_interface/panels/settings/number_display_buttons.tres")

func _ready() -> void:
	a.pressed.connect( _on_number_display_button_pressed )
	%SaveButton
	%SaveExitButton.pressed.connect( func(): self.hide() )
	%ExitButton


func _on_number_display_button_pressed(button):
	GameData.settings.number_display = button.get_index()
	pass

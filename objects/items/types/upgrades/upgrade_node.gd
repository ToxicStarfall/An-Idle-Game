extends ItemNode
class_name UpgradeNode


#var upgrade_resource: Upgrade


func _ready() -> void:
	pressed.connect( _on_upgrade_pressed )
	mouse_entered
	mouse_exited
	pass


func _on_upgrade_pressed():
	# check if buyable
	# play visual effects
	pass


func _on_update_content():
	pass

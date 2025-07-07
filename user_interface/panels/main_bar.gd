extends Panel


var meditate_active = false


@onready var KnowledgeLabel = %KnowledgeLabel
@onready var PowerLabel = %PowerLabel

@onready var ThoughtProgressBar = %ThoughtProgressBar
@onready var ThoughtButton = %ThoughtButton2
@onready var ThoughtEarnLabel = %ThoughtEarnLabel


func _ready() -> void:
	ThoughtButton.pressed.connect( func():
		Events.thought_progressed.emit()
		#Events.trigger_event.emit( MessageEvent.new("Somthing was clicked!") )
		)
	#%MeditateButton.pressed.connect( func(): meditate_active = !meditate_active ) # toggle meditate_active
	%MeditateButton.pressed.connect( func(): _toggle_meditate(!meditate_active) ) # toggle meditate_active

	Events.update_knowledge_counters.connect( _on_update_knowledge_counters )
	Events.update_power_counters.connect( _on_update_power_counters )

	Events.ui_thought_progressed.connect( _on_ui_thought_progressed )
	Events.ui_thought_completed.connect( _on_ui_thought_completed )
	Events.thoughtProgressReq_changed.connect( _on_thoughtProgressReq_changed )
	pass


func _process(_delta: float) -> void:
	# Use process for MeditateButton to calculate time/reward more accurately
	pass


func _toggle_meditate(overide_state = null):
	if overide_state != null: meditate_active = overide_state  # Change state if a new state is provided
	meditate_active = meditate_active  # Keep the same state as before

	if meditate_active:
		%MeditateButton.text = "MEDITATE: ON"
		var time = GameData.meditateBaseSpeed / GameData.meditateSpeedPercentMult
		await get_tree().create_timer(time).timeout
		Events.thought_progressed.emit(true)
		_toggle_meditate()  # Restart timer
	else:
		%MeditateButton.text = "MEDITATE: OFF"
		pass



func _on_update_knowledge_counters(knowledge, _knowledgeE):
	KnowledgeLabel.text = "%s knowledge" %[str(knowledge)]


func _on_update_power_counters(power, _powerE):
	PowerLabel.text = "%s power" % [power]


func _on_ui_thought_progressed(new_progress):
	ThoughtProgressBar.value = new_progress


func _on_ui_thought_completed(new_progress):
	ThoughtProgressBar.value = new_progress

# Only change max_value whenever progressReq changes
# progressReq changes when value = max_value
func _on_thoughtProgressReq_changed(progress_req):
	ThoughtProgressBar.max_value = progress_req
	ThoughtEarnLabel.text = str(progress_req)

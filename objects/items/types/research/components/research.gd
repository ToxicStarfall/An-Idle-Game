class_name Research
extends Item


## research time in miliseconds
@export var research_time: float = 0
@export var position_overide: Vector2


func _init() -> void:
	self.type = Type.RESEARCH


## Set state to [State.OWNED] and applies costs, effects, vfx
# InputEvent supplied for [MessageEvent] popups.
func buy():
	if state == State.LOCKED:
		print("This item is LOCKED.")
	if state == State.OWNED:
		print("You already own \"%s\"" % [self.name])
	if state == State.UNLOCKED:  # If not alerady owned
		var valid = true
		for requirement in requirements:
			# Cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false
		for requirement in costs:
			# Cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false

		if valid:
			set_state( State.OWNED )
			_apply_costs()
			_apply_effects()
			# tween pop/unlock effect,
			# remove node and move to database
			MessageEvent.new("Item bought [url]%s[/url]" % [self.name], self).call_event()
			MessageEvent.new("Item bought!", null, 3.0) .popup() .call_event()
		else:
			MessageEvent.new("Cannot buy %s." % [self.name], self, 3.0).call_event()


#func _set_state(new_state: Item.State):
	#super( new_state )
	# connector lines are updated in research_node.gd
	#pass

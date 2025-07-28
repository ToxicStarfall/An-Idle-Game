class_name ScriptedEvent
extends Item


# Ovveride default buy method
func buy():
	if state == State.LOCKED:  # If not alerady owned
		var valid = true
		# Cancel purchase if a requirement is not met
		for requirement in requirements:
			if requirement.check() == false:
				valid = false

		if valid:
			set_state( State.OWNED )
			#_apply_costs()
			_apply_effects()

			#MessageEvent.new("Item bought [url]%s[/url]" % [self.name], self).call_event()
			#MessageEvent.new("Item bought!", null, 3.0)\
				#.popup()\
				#.call_event()
			print("new Event  \"%s\":%s" % [self.name, get_requirements()])
		else:
			#Events.trigger_event.emit( MessageEvent.new("Item bought [url]%s[/url]" % [self.name], self) )
			#MessageEvent.new("Cannot buy %s." % [self.name], self, 3.0).call_event()
			#print("Cannot buy. \"%s\" requires %s" % [self.name, get_costs()])
			pass

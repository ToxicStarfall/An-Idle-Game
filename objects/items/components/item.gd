extends Resource
class_name Item


signal update_state(state)
#signal update_content

enum Type {
	BASE,
	UPGRADE,
	RESEARCH,
	GENERATOR
}

enum State {
	LOCKED,
	UNLOCKED,
	OWNED
}

enum Tags { WEAPONS, UPGRADE }

#@export_category("Debug")
@export var disabled = false  ## For debug purposes

@export_category("Properties")
@export var icon: Texture2D = preload("res://icon.svg")
@export_placeholder("Item Name") var name: String = ""
@export_multiline var description: String = "I am a description."
@export_multiline var flair: String = "I am descriptive flair."

## Requirement(s) spent to purchase/obtain this item.
@export var costs: Array[CostCurrency] = []
## Requirement(s) needed prior to obtaining this item.
@export var requirements: Array[Requirement] = []
##
@export var unlockRequirements: Array[Requirement] = []
## A list of effects modifying game stats (ie: clickPower).
@export var effects: Array[ItemEffect] = []
##
@export var state: State = State.LOCKED
## Tags for sorting and filters.  INCLUDES INTERNAL TAGS
#@export var tags: ItemTags = ItemTags.new()
@export var tags := ItemTags.new()
#@export var tags: Array[Tags] = []
#@export_flags("a", "b") var tags

var raw_name  ## Plain item name
var type := Type.BASE  ## Used for Match comparisons for different item types.


#enum InternalTags {}


func _init(item_type: Type = Type.BASE) -> void:
	self.type = item_type
	if disabled:
		pass
	#if name == null:  # use resource_name if a defualt is not present
		#name = resource_name.split(":")[1]
		#print(self, " has naming error")


## Sets state to [State.UNLOCKED] if requirements are met.
func unlock():
	if state < State.UNLOCKED:  # Enum comparison, if this item is currently LOCKED(0)
		var valid = true
		for requirement in requirements:
			# Cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false

		if valid:
			set_state( State.UNLOCKED )
			print("Item unlocked: \"%s\"" % [self.name])
		else:
			#print("Cannot unlock. \"%s\" requires %s" % [self.name, _get_requirements()])
			pass


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
			MessageEvent.new("Item bought [url]%s[/url]" % [self.name], self)\
				.popup()\
				.call_event()
			#print("Bought \"%s\" for %s" % [self.name, get_costs()])
		else:
			#Events.trigger_event.emit( MessageEvent.new("Item bought [url]%s[/url]" % [self.name], self) )
			MessageEvent.new("Cannot buy %s." % [self.name], self, 3.0).call_event()
			#print("Cannot buy. \"%s\" requires %s" % [self.name, get_costs()])


## Loops through costs[] and applies them.
func _apply_costs():
	for cost in costs:
		cost.apply()


## Loops through effects[] and applies them.
func _apply_effects():
	for effect in effects:
		effect.apply()
		pass


## Returns costs as "current/total" in a Array format.
func get_costs():
	var string: String = ""
	if costs.is_empty():
		string += "Free"
	else:
		for cost in costs:
			if cost.check():
				string += "[color=green]%s %s[/color]\n" % [cost.value, cost.currency]
			else:
				string += "[color=red]%s %s[/color]\n" % [cost.value, cost.currency]
	return string


## Returns costs as "current/total" in a Array format.
func get_requirements():
	var array = []
	for requirement in requirements:
		var string
		match typeof(requirement):
			RequirementCurrency:
				string = "%s / %s %s" % [Game.get_property(requirement.currency), requirement.value, requirement.currency]
				array.append( string )
			RequirementItem:
				string = "item:%s - state:%s" % [requirement.item.name, requirement.state]
				array.append( string )
	return array


## Returns tags in "[TAG][TAG2]" format.
func get_tags():
	var string: String = ""
	for tag in tags.internal_tags:
		string += " [%s]" % [tag]
	return string


## Changes and sets new state, send update signals to [Game] & [ItemNode]
func set_state(new_state: Item.State):
	#print("newstate: ", new_state)
	self.state = new_state
	#print("state set to ", new_state)
	update_state.emit( new_state )
	Events.item_state_changed.emit(get_script().get_global_name())
	pass


## Checks if this item missing any properties.  If true, disable this item.
func _validate():
	pass

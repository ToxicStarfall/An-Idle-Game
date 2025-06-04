extends Resource
class_name Item


signal update_state(state)

#@export_category("Debug")
@export var disabled = false  ## For debug purposes

@export_category("Properties")
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
@export var tags: ItemTags = ItemTags.new()
#@export var tags: Array[Tags] = []
#@export_flags("a", "b") var tags

var raw_name # plain file name

enum Tags { WEAPONS, UPGRADE }
#enum InternalTags {}
enum State { LOCKED, UNLOCKED, OWNED }
#enum { LOCKED, UNLOCKED, OWNED }


func _init() -> void:
	if disabled:
		pass
	if name == null:  # use resource_name if a defualt is not present
		name = resource_name.split(":")[1]
		print(self, " has naming error")


func unlock():
	# if state != State.UNLOCKED and state != State.OWNED
	if state < State.UNLOCKED: #!unlocked:
		var valid = true
		for requirement in requirements:
			# cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false

		if valid:
			_set_state( State.UNLOCKED )
			print("Item unlocked: \"%s\"" % [self.name])
		else:
			#print("Cannot unlock. \"%s\" requires %s" % [self.name, _get_requirements()])
			pass


func buy():
	if state == State.LOCKED: print("This item is LOCKED.")
	if state == State.OWNED: #owned:
		print("You already own \"%s\"" % [self.name])
	if state == State.UNLOCKED: #not owned
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
			_set_state( State.OWNED )
			_apply_costs()
			_apply_effects()
			# tween pop/unlock effect,
			# remove node and move to database

			print("Bought \"%s\" for {stuff}" % [self.name])
		else:
			print("Cannot buy. \"%s\" requires %s" % [self.name, _get_costs()])


func _apply_costs():
	for cost in costs:
		cost.apply()

func _apply_effects():
	for effect in effects:
		effect.apply()
		pass


# Returns costs as "current/total" in a Array format.
func _get_costs():
	var array = []
	for requirement in costs:
		var string
		#var str = "%s/%s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
		match typeof(requirement):
			CostCurrency:
				string = "%s / %s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
				array.append( string )
	return array


# Returns costs as "current/total" in a Array format.
func _get_requirements():
	var array = []
	for requirement in requirements:
		var string
		match typeof(requirement):
			RequirementCurrency:
				string = "%s / %s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
				array.append( string )
			RequirementItem:
				string = "item:%s - state:%s" % [requirement.item.name, requirement.state]
				array.append( string )
	return array


func _get_tags():
	pass


func _set_state(new_state: Item.State):
	self.state = new_state
	#print("state set to ", new_state)
	update_state.emit( new_state )
	Game._update_items( get_script().get_global_name()) # clean this up later
	pass


func _validate():
	pass

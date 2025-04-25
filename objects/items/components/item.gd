extends Resource
class_name Item


#@export_category("Debug")
@export var disabled = false  ## For debug purposes

@export_category("Properties")
@export_placeholder("Item Name") var name: String = ""
@export_multiline var description: String = "I am a description."
@export_multiline var flair: String = "I am descriptive flair."

## Requirement(s) spent to purchase/obtain this item.
@export var costs: Array[CurrencyCost] = []
## Requirement(s) needed prior to obtaining this item.
@export var requirements: Array[Requirement] = []
##
@export var unlockRequirements: Array[Requirement] = []
## A list of effects modifying game stats (ie: clickPower).
@export var effects: Array[ItemEffect] = []
##
@export var state: int = LOCKED
#@export var owned: bool = false
#@export var unlocked: bool = false
## Tags for sorting and filters.  INCLUDES INTERNAL TAGS
@export var tags: ItemTags = ItemTags.new()
#@export var tags: Array[Tags] = []
#@export_flags("a", "b") var tags
enum Tags { WEAPONS, UPGRADE }
enum InternalTags {}
enum State { LOCKED, UNLOCKED, OWNED }
enum { LOCKED, UNLOCKED, OWNED }


func _init() -> void:
	if disabled:
		pass

	if name == null:  # use resource_name if a defualt is not present
		name = resource_name


func unlock():
	# if state != State.UNLOCKED and state != State.OWNED
	if state < UNLOCKED: #!unlocked:
		var valid = true
		for requirement in requirements:
			# cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false

		if valid:
			state = UNLOCKED
			print("Item unlocked: \"%s\"" % [self.name])
		else:
			#print("Cannot unlock. \"%s\" requires %s" % [self.name, _get_requirements()])
			pass


func buy():
	if state == LOCKED: print("This item is LOCKED.")
	if state == OWNED: #owned:
		print("You already own \"%s\"" % [self.name])
	if state == UNLOCKED: #not owned
		var valid = true
		for requirement in requirements:
			# cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false
		for requirement in costs:
			# cancel purchase if a requirement is not met
			if requirement.check() == false:
				valid = false

		if valid:
			#owned = true
			state = OWNED
			_apply_costs()
			_apply_effects()
			#self.text += "\nBought"
			# update
			print("Bought \"%s\" for {stuff}" % [self.name])
		else:
			print("Cannot buy. \"%s\" requires %s" % [self.name, _get_costs()])


func _apply_costs():
	for cost in costs:
		cost.apply()

func _apply_effects():
	for effect in effects:
		#effect.apply()
		pass


## Returns costs as "current/total" in a Array format.
func _get_costs():
	var array = []
	for requirement in costs:
		var string
		#var str = "%s/%s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
		match typeof(requirement):
			CurrencyCost:
				string = "%s / %s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
				array.append( str )
	return array


## Returns costs as "current/total" in a Array format.
func _get_requirements():
	var array = []
	for requirement in requirements:
		var string
		match typeof(requirement):
			CurrencyRequirement:
				string = "%s / %s %s" % [Game.find_property(requirement.currency), requirement.value, requirement.currency]
				array.append( str )
			ItemRequirement:
				string = "item:%s - state:%s" % [requirement.item.name, requirement.state]
				array.append( str )
	return array



func _validate():
	pass

extends Node


var save_data = SaveFile.new()

#region - - - Resources - - - - #

#@export var weapons: int = 0  ## number of weapons produced
#@export var weapons = Weapons.new()
#@export var weaponsE: int = 0  ## highest number of weapons produced
#@export var weaponPower: float = 0.0 : #set = _get_weaponsPC
	#set(value):
		#if value>weaponPower: weaponPowerE += (value-weaponPower)
		##print("weaponPowerE: ",weaponPowerE)
		#weaponPower = value
#@export var weaponPowerE: float = 0.0
#@export var weaponsPC: float = 0.0 #: get = _get_weaponsPC
#@export var weaponsPS: float = 0
#@export var weaponsBasePC: int = 1 : #set = _get_weaponsPC
	#set(value):
		#weaponsBasePC = value
		#_get_weaponsPC()
#@export var weaponsBasePS: int = 0 #: set = _set_weaponsPS


#region Currency - Power
@export var power: float = 0.0 :           ## Total [Power] acumalated.
	set(value):
		_set_currency("power", value)
		# If new value is higher than current value, add to total earnt.
		#if value>power: powerE += (value-power)
		#power = value
		Events.update_power_counters.emit(power, powerE)
	get: return _get_currency("power")
@export var powerE: float = 0.0 :          ## Total lifetime [Power] acumalated.
	set(value): _set_prop("powerE", value)
	get: return _get_prop("powerE")
#var powerPC: float = 0.0
#@export var powerPCBase: float = 0.0
#@export var powerPCMult: float = 0.
var powerEarn: float = 0.0 :          ## Total [Power] earnt as part of [Thought] completion.
	get: return _get_powerEarn()
@export var powerEarnBase: int = 1 :         ## Base [Power] earnt per [Thought]
	set(value): _set_prop("powerEarnBase", value)
	get: return _get_prop("powerEarnBase")
@export var powerEarnBasePct: float = 0.2 :  ## [Power] earnt as a % of [Knowledge] from [Thought].
	set(value): _set_prop("powerEarnBasePct", value)
	get: return _get_prop("powerEarnBasePct")
#endregion


#region Knowledge & Research
@export var insight: int = 0   # High level research resource used to unlock core technologies
@export var knowledge: float = 0 :
	set(value):
		_set_currency("knowledge", value)
		# If new value is higher than current value, add to total earnt.
		#if value>knowledge: knowledgeE += (value-knowledge)
		#print("knowledgeE: ",knowledge)
		#knowledge = value
		Events.update_knowledge_counters.emit( snappedf(knowledge, 1.0), snappedf(knowledgeE, 1.0))
	get: return _get_currency("knowledge")
@export var knowledgeE: float = 0 :
	set(value): _set_prop("knowledgeE", value)
	get: return _get_prop("knowledgeE")
#@export var knowledgePS: float = 0 #: set = _set_knowledgePS
#@export var knowledgeBasePS: int = 0

## Completing [Thoughts] grants [Knowledge].
@export var thoughtE: int = 0 :          ## Number of [Thoughts] completed.
	set(value): _set_prop("thoughtE", value)
	get: return _get_prop("thoughtE")
@export var thoughtProgress: int = 0 :   ## Current completion progress of [Thought].
	set(value): _set_prop("thoughtProgress", value)
	get: return _get_prop("thoughtProgress")
@export var thoughtProgressReq: int = 0 :
	set(value):
		thoughtProgressReq = thoughtEarn
		Events.thoughtProgressReq_changed.emit( thoughtProgressReq )
		return thoughtEarn

## The amount that the current [Thought] is filled by.
#@export var thoughtPower: float = 0 :        ## Thought fill amount.
var thoughtPower: float = 0 :        ## Thought fill amount.
	get = _get_thoughtPower
@export var thoughtPowerBase: int = 1:
	set(value): _set_prop("thoughtPowerBase", value)
	get: return _get_prop("thoughtPowerBase")
#@export var thoughtPowerMult: float = 1
#@export var thoughtPowerRand: float = 0.25  # Randomness of thought fill amount.

## Amount of earnt knowledge per Thought completed.
@export var thoughtEarn: float = 0:
#var thoughtEarn: float = 0:
	set(value):
		thoughtEarn = value
		Events.thoughtEarn_changed.emit(value)
	#get: return _get_prop("thoughtEarnBase")
@export var thoughtEarnBase: int = 3:
	set(value):
		thoughtEarnBase = value
		_get_thoughtEarn()
	#set(value): _set_prop("thoughtEarnBase", value)
	#get: return _get_prop("thoughtEarnBase")
#@export var thoughtEarnMult: float = 1 #: set = _get_thoughtEarn
#@export var thoughtEarnRand: float = -0.25   # Randomness of earnt knowledge earnt per Thought
#@export var thoughtEarnRandMax: float = 0.1  # Randomness maximum
#@export var thoughtEarnScale: float = 1.2

#@export var meditateEarnBase: float =
@export var meditateBaseSpeed: float = 2.0     ## Each meditate increment takes this amount of time in seconds
@export var meditateSpeedPercentMult: float = 1.0  ## Additive percent speed multiplier
#@export var meditateSpeedMult: float = 1.0     ## Multiplicative speed multiplier

#@export var currentResearch = null
#@export var currentResearchProgress = 0
#endregion

#endregion


#region - - - Items - - - - #
@export var upgrades: Dictionary[String, Item] = {} # Dict{ Item }
@export var research: Dictionary[String, Item] = {}

@export var generator_cost_scale = 1.12 # 1.15 is used by cookieclicker
@export var generators: Dictionary[String, Item] = {}
#endregions


@export var ui: Dictionary[String, bool] = {
	"MeditateButton": false,
	"RelationsPanel": false,
}
@export var ui_hint: Dictionary[String, bool] = {
	"ResearchProgress": true
}
@export var scripted_events: Dictionary = {}


#func _init() -> void:
	#pass

## Set the initial calculated values, Causes update signal to emit for values
func initialize_values():
	_get_thoughtPower()
	_get_thoughtEarn()
	print("thoughtEarn",thoughtEarn)
	set("thoughtProgressReq", thoughtEarn)
	#Events.ui_thought_progressed.emit()
	#Events.thoughtProgressReq_changed.emit(thoughtProgressReq)
	_get_powerEarn()
	#Events.update_knowledge_counters.emit(knowledge, knowledgeE)
	#print(Events.update_knowledge_counters.get_connections())
	set("knowledge", knowledge)


# Setter for subresources.  (UNUSED currently)
#func _set_resourcePC(resource_type):
	#var resource = Game.get_property(resource_type)
	#if resource:
		#var a = resource_type.slice(0,1)
		#resource_type.erase(0,1)
		#a.to_upper()
		#a += resource_type
		#resource = Game.get_property("base%s" % [resource_type])
	#return resource

#region  - - SETTERS & GETTERS - - - - #
# - - - GENERIC SETTERS - - - - #
func _set_prop(key, value):
	save_data.set(key, value)


func _get_prop(key):
	return save_data.get(key)


# - - - CURRENCY SETTERS - - - - #
func _set_currency(currency: String, value):
	# If new value is higher than current value, add to total earnt.
	if value > get(currency):
		var currencyE = currency + "E"
		var diff = value - get(currency)
		set(currencyE, diff + get(currency))  # Add the difference
		#print(diff, "  value",value, " - currency",get(currency))
		#print("currencyE - ", currencyE, " - ", get(currencyE))
	save_data.set(currency, value)
	# Currency update signals are emitted after calling this function in "set(value):"
	# Items are not being updated for some reason


func _get_currency(key):
	return save_data.get(key)


# - - - ITEM SETTERS - - - - #
func _set_item():
	pass


func _get_item():
	pass

#endregion


#region - - - STAT CALCULATIONS - - - - #
## Calculates [powerEarn] and returns the value.
func _get_powerEarn() -> float:
	#powerEarn = powerEarnBase
	#powerEarn = powerEarnBasePct
	var calculated_value  = powerEarnBase
	return calculated_value#powerEarn


func _get_thoughtPower():
	thoughtPower = thoughtPowerBase
	#thoughtPower *= thoughtPowerMult
	#thoughtPower += (thoughtPowerBase * randf_range(thoughtPowerRand, thoughtPowerRandMax))
	#thoughtPower = float( int(thoughtPower * 100) ) / 100  # round to hundreths place
	return thoughtPower


func _get_thoughtEarn(_value=0):
	#thoughtEarnBase = value
	thoughtEarn = thoughtEarnBase
	#thoughtEarn += (thoughtEarnBase * randf_range(thoughtEarnRand, thoughtEarnRandMax))
	#thoughtEarn = float( int(thoughtEarn * 10) ) / 10  # Rounds to hundreths place
	#print("thoughtEarn pudated - ", str(thoughtEarnBase))
	Events.thoughtEarn_changed.emit(thoughtEarn)
	#return thoughtEarn
	return _value

#endregion



func _ready() -> void:
	Events.resource_added.connect( _on_resource_added )
	Events.resource_removed.connect( _on_resource_removed )

	Events.item_state_changed.connect( update_items ) # signals for update_ietms when a item's state changes

	Events.thought_progressed.connect( _on_thought_progressed )
	#Events.thought_completed.connect( func(): )


func update_items(filter_tag):
	const Tags = ItemTags.Tags
	filter_tag = filter_tag.to_upper()  # All tags are CAPITALIZED
	#print("Updating items with tag: ", filter_tag)
	for type in [upgrades, research, generators]:
		for i in type:
			# UI Unlocks
			#if i is Control:
				#if item.
				#item.unlock()
				#pass

			var valid_filter
			var item = type[i]
			#print(item.name)
			var tag = Tags.find_key(Tags.get(filter_tag))
			if item.tags.internal_tags.has(tag):
				#print("  matching item: ", item.name)
				valid_filter = true

			if item.state == item.State.LOCKED and valid_filter:#item.tags.has(filter_tag):
				item.unlock()
	# Update scripted events seperately.
	for i in scripted_events:
		var item = scripted_events[i]
		var valid_filter
		var tag = Tags.find_key(Tags.get(filter_tag))  # Check if the tag exists in [Tags].
		if item.tags.internal_tags.has(tag):           # Compare to see it the item has it too.
			#print("  matching item: ", item.name)
			valid_filter = true
		if item.state == item.State.LOCKED and valid_filter:
			item.buy()  # Ignore the UNLOCKED state, skip directly to OWNED.


func _on_resource_added( resource_type: String, amount: float ):
	var resource = get(resource_type)
	resource += amount
	set(resource_type, resource)
	update_items(resource_type)


func _on_resource_removed( resource_type: String, amount: float ):
	var resource = get(resource_type)
	resource -= amount
	set(resource_type, resource)
	update_items(resource_type)



func _on_thought_progressed(meditate_active := false):
	if meditate_active:
		pass
	thoughtProgress += thoughtPower
	Events.ui_thought_progressed.emit( thoughtProgress )

	if thoughtProgress >= thoughtProgressReq: # When thought completed
		thoughtE += 1
		Events.resource_added.emit("knowledge", thoughtEarn)
		Events.resource_added.emit("thoughtEarnBase", 1)  # grdually scale value

		# Power yield per thought completed
		#Events.resource_added.emit("power", powerEarn) # add additional percent yield
		#print(powerEarn, "powerEarn")

		var overflow_progress = thoughtProgress - thoughtProgressReq
		thoughtProgress = overflow_progress
		thoughtProgressReq = thoughtEarn  # Setter update
		Events.ui_thought_completed.emit(thoughtProgress)

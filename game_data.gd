extends Node


var save_data = SaveData.new()

#region - - - Resources - - - - #
#@export var weapons: int = 0  ## number of weapons produced
#@export var weapons = Weapons.new()
#@export var weaponsE: int = 0  ## highest number of weapons produced
#@export var weaponPower: float = 0.0 : #set = _update_weaponsPC
	#set(value):
		#if value>weaponPower: weaponPowerE += (value-weaponPower)
		##print("weaponPowerE: ",weaponPowerE)
		#weaponPower = value
#@export var weaponPowerE: float = 0.0
#@export var weaponsPC: float = 0.0 #: get = _update_weaponsPC
#@export var weaponsPS: float = 0
#@export var weaponsBasePC: int = 1 : #set = _update_weaponsPC
	#set(value):
		#weaponsBasePC = value
		#_update_weaponsPC()
#@export var weaponsBasePS: int = 0 #: set = _set_weaponsPS


@export var power: float = 0.0 :            ## Total [Power] acumalated.
	set(value):
		# If new value is higher than current value, add to total earnt.
		if value>power: powerE += (value-power)
		power = value
		Events.update_power_counters.emit(power, powerE)
	#get:
		#_update_powerEarn()
		#return power
@export var powerE: float = 0.0            ## Total lifetime [Power] acumalated.
# @export var powerPC: float = 0.0
# @export var powerPCBase: float = 0.0
# @export var powerPCMult: float = 0.
@export var powerEarn: float = 0.0           ## Total [Power] earnt as part of [Thought] completion.
@export var powerEarnBase: int = 1 :         ## Base [Power] earnt per [Thought]
	#set(value): _set_power("powerEarnBase", value)
	#get: return _get_power("powerEarnBase")
	set(value):
		powerEarnBase = value
		_update_powerEarn()
@export var powerEarnBasePct: float = 0.2 :  ## [Power] earnt as a % of [Knowledge] from [Thought].
	set(value): _set_power("powerEarnBasePct", value)
	get: return _get_power("powerEarnBasePct")
var _power_properties = {}


@export var insight: int = 0   # High level research resource used to unlock core technologies
@export var knowledge: float = 0 :
	set(value):
		# If new value is higher than current value, add to total earnt.
		if value>knowledge: knowledgeE += (value-knowledge)
		#print("knowledgeE: ",knowledge)
		knowledge = value
		Events.update_knowledge_counters.emit(knowledge, knowledgeE)
@export var knowledgeE: float = 0
#@export var knowledgePS: float = 0 #: set = _set_knowledgePS
#@export var knowledgeBasePS: int = 0

# Completing [Thoughts] grants [Knowledge].
@export var thoughtE: int = 0            ## Number of Thoughts completed.
@export var thoughtProgress: int = 0     ## Current completion progress of thought
@export var thoughtProgressReq: int = 0 :
	set(value):
		thoughtProgressReq = thoughtEarn
		Events.thoughtProgressReq_changed.emit( thoughtProgressReq )
		return thoughtEarn

@export var thoughtPower: float = 0 #:        # Thought fill amount.
	#get = _update_thoughtPower
@export var thoughtPowerBase: int = 1:
	set(value):
		thoughtPowerBase = value
		_update_thoughtPower()
#@export var thoughtPowerMult: float = 1
#@export var thoughtPowerRand: float = 0.25  # Randomness of thought fill amount.

# Amount of earnt knowledge per Thought completed.
@export var thoughtEarn: float = 0:
	set(value):
		thoughtEarn = value
		Events.thoughtEarn_changed.emit(value)
@export var thoughtEarnBase: int = 3:
	set(value):
		thoughtEarnBase = value
		_update_thoughtEarn()
#@export var thoughtEarnMult: float = 1 #: set = _update_thoughtEarn
#@export var thoughtEarnRand: float = -0.25   # Randomness of earnt knowledge earnt per Thought
#@export var thoughtEarnRandMax: float = 0.1  # Randomness maximum
#@export var thoughtEarnScale: float = 1.2

#@export var currentResearch = null
#@export var currentResearchProgress = 0

#endregion


#region - - - Items - - - - #
@export var upgrades = {} # Dict{ Item }
@export var research = {}

@export var generator_cost_scale = 1.12 # 1.15 is used by cookieclicker
@export var generators = {}
#endregion

@export var ui = {
	"MeditateButton": false,
	"RelationsPanel": false,
}



func _init() -> void:
	#_update_weaponsPC()

	pass

func initilize_values():
	_update_thoughtPower()
	_update_thoughtEarn()
	set("thoughtProgressReq", thoughtEarn)
	#Events.ui_thought_progressed.emit()
	#Events.thoughtProgressReq_changed.emit(thoughtProgressReq)
	_update_powerEarn()
	pass


#region - - - SETTERS & GETTERS - - - - #

#func _set_resourcePC(resource_type):
	#var resource = Game.get_property(resource_type)
	#if resource:
		#var a = resource_type.slice(0,1)
		#resource_type.erase(0,1)
		#a.to_upper()
		#a += resource_type
		#resource = Game.get_property("base%s" % [resource_type])
	#return resource

#func _update_weaponsPC():
	##weaponsPC = weaponsBasePC
	#pass
#func _update_weaponsPS(_value):
	#return


func _set_power(key, value):
	save_data.set(key, value)
	#_power_properties[key] = value
	_update_powerEarn()

func _get_power(key):
	#print(save_data.get(key))
	return save_data.get(key)
	#return _power_properties.get(key)


func _update_powerEarn():
	powerEarn = powerEarnBase
	#powerEarn = powerEarnBasePct


func _update_thoughtPower(_value=0):
	thoughtPower = thoughtPowerBase
	#thoughtPower *= thoughtPowerMult
	#thoughtPower += (thoughtPowerBase * randf_range(thoughtPowerRand, thoughtPowerRandMax))
	#thoughtPower = float( int(thoughtPower * 100) ) / 100  # round to hundreths place
	#return value
	#return thoughtPower

func _update_thoughtEarn(_value=0):
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
	filter_tag = filter_tag.to_upper()
	#print("Updating items with tag: ", filter_tag)
	for type in [upgrades, research, generators]:
		for i in type:
			# UI Unlocks
			#if i is Control:
				#if item.
				#item.unlock()
				#pass

			const Tags = ItemTags.Tags
			var item = type[i] #game_data.upgrades[i]
			#print(item.name)
			var valid_filter
			var tag = Tags.find_key(Tags.get(filter_tag))
			if item.tags.internal_tags.has( tag ):#item.tags.Tags[filter_tag] ):
				#print("matching item: ", item.name)
				valid_filter = true

			if item.state == item.State.LOCKED and valid_filter:#item.tags.has(filter_tag):
				item.unlock()


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



func _on_thought_progressed():
	thoughtProgress += thoughtPower
	Events.ui_thought_progressed.emit( thoughtProgress )

	if thoughtProgress >= thoughtProgressReq: # When thought completed
		thoughtE += 1
		Events.resource_added.emit("knowledge", thoughtEarn)
		Events.resource_added.emit("thoughtEarnBase", 1)  # grdually scale value

		# Power yield per thought completed
		Events.resource_added.emit("power", powerEarn) # add additional percent yield
		#print(powerEarn, "powerEarn")

		var overflow_progress = thoughtProgress - thoughtProgressReq
		thoughtProgress = overflow_progress
		thoughtProgressReq = thoughtEarn  # Setter update
		Events.ui_thought_completed.emit(thoughtProgress)

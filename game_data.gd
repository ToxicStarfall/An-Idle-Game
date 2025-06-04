extends Resource
class_name GameData

#@export var player_name: String = "Player1"
#@export var sessions: int = 0
#@export var sessionPlaytime: int = 0
#@export var longestSessionPlaytime: int = 0
#@export var totalPlaytime: int = 0

#region - - - Resources - - - - #
#@export var weapons: int = 0  ## number of weapons produced
#@export var weapons = Weapons.new()
#@export var weaponsE: int = 0  ## highest number of weapons produced
@export var weaponPower: float = 0.0 : #set = _update_weaponsPC
	set(value):
		if value>weaponPower: weaponPowerE += (value-weaponPower)
		#print("weaponPowerE: ",weaponPowerE)
		weaponPower = value

@export var weaponPowerE: float = 0.0
@export var weaponsPC: float = 0.0 #: get = _update_weaponsPC
@export var weaponsPS: float = 0
@export var weaponsBasePC: int = 1 : #set = _update_weaponsPC
	set(value):
		weaponsBasePC = value
		_update_weaponsPC()
@export var weaponsBasePS: int = 0 #: set = _set_weaponsPS

@export var knowledge: float = 0 :
	set(value):
		if value>knowledge: knowledge += (value-knowledge)
		#print("knowledgeE: ",knowledge)
		knowledge = value
@export var knowledgeE: float = 0

# Filling/completing thoughts grants knowledge.
@export var thoughtE: int = 1              # Number of Thoughts completed.
@export var thoughtProgress: float = 0 :     # Current Thought progress.
	set(value):
		thoughtProgress = clamp(value, 0, 1)
		#if value == 100: knowledge += knowledgePC
@export var thoughtFillAmount: float = 0.2  # Thought fill amount.
#@export var thoughtFillRand: float = 0.50   # Randomness of thought fill amount.
@export var thoughtEarn: float = 0 :        # Amount of earnt knowledge per Thought completed.
	get:
		return thoughtEarnBase
@export var thoughtEarnBase: int = 10      # Base amount of earnt knowledge per Thought completed.
#@export var thoughtEarnMult: int = 1
#@export var thoughtEarnRand: float = 0.50  # Randomness of earnt knowledge earnt per Thought

#@export var knowledgePS: float = 0 #: set = _set_knowledgePS
#@export var knowledgeBasePS: int = 0

#@export var currentResearch = null
#@export var currentResearchProgress = 0
#endregion

#region - - - Items - - - - #
@export var upgrades = {} # Dict{ Item }
@export var research = {}

@export var generators = {}
#endregion


func _init() -> void:
	_update_weaponsPC()
	Events.resource_added.connect(a)
	pass
func a(a,b):
	pass

#region - - - SETTERS & GETTERS - - - - #

#func _set_resourcePC(resource_type):
	#var resource = Game.find_property(resource_type)
	#if resource:
		#var a = resource_type.slice(0,1)
		#resource_type.erase(0,1)
		#a.to_upper()
		#a += resource_type
		#resource = Game.find_property("base%s" % [resource_type])
	#return resource


func _update_weaponsPC():
	weaponsPC = weaponsBasePC
	# apply multipliers


func _update_weaponsPS(value):
	# apply multipliers
	return


#endregion

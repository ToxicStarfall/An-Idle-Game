extends Resource
class_name GameData


signal update_items(filter_tag)

#@export var player_name: String = "Player1"
#@export var sessions: int = 0
#@export var sessionPlaytime: int = 0
#@export var longestSessionPlaytime: int = 0
#@export var totalPlaytime: int = 0

#region - - - Resources - - - - #
#@export var weapons: int = 0  ## number of weapons produced
@export var weapons = Weapons.new()
@export var weaponPower: float = 0.0
@export var weaponPowerE: float = 0.0
@export var weaponsPC: float = 0.0 #: get = _update_weaponsPC
#@export var weaponsPS: float = 0
@export var weaponsBasePC: int = 1 : #set = _update_weaponsPC
	set(_value):
		_update_weaponsPC()
#@export var baseWeaponsPS: int = 0 #: set = _set_weaponsPS

#@export var researchPower: float = 0
#@export var researchPC: float = 0 #: set = _set_weaponsPC
#@export var baseResearchPC: int = 0
#@export var researchPS: float = 0 #: set = _set_weaponsPC
#@export var baseResearchPS: int = 0

#@export var currentResearchProject = null
#@export var currentResearchProgress = 0
#endregion

#region - - - Items - - - - #
@export var upgrades = {} # Dict{ Item }
#@export var generators = {}
#endregion


func _init() -> void:
	update_items.connect( _update_items )
	_update_weaponsPC()
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


func _update_items(filter_tag):
	filter_tag = filter_tag.to_upper()

	#print("Updating items with tag: ", filter_tag)
	for i in upgrades:
		var item = upgrades[i]

		var valid_filter
		#if filter_tag.contains("."):
			#filter_tag = filter_tag.insert(8, ".")
			#filter_tag = filter_tag.replace(".", "")
			#filter_tag = "".join(filter_tag.split("."))
			#print("removed period")
			#pass
		if item.tags.taglist.has( item.tags.Tags[filter_tag] ):
			valid_filter = true#item.tags.taglist.has( )
			pass

		if item.state == item.State.LOCKED and valid_filter:#item.tags.has(filter_tag):
			item.unlock()

#endregion

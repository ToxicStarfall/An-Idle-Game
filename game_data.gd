extends Node



var player_name: String = "Player1"
var sessions: int = 0
var sessionPlaytime: int = 0
var longestSessionPlaytime: int = 0
var totalPlaytime: int = 0


var weapons: int = 0  # number of weapons produced
var weaponPower: float = 0
var weaponsPC: float = 0 : get = _update_weaponsPC
var baseWeaponsPC: int = 1 #: set
var weaponsPS: float = 0
var baseWeaponsPS: int = 0 #: set = _set_weaponsPS

var researchPower: float = 0
var researchPC: float = 0 #: set = _set_weaponsPC
var baseResearchPC: int = 0
var researchPS: float = 0 #: set = _set_weaponsPC
var baseResearchPS: int = 0


var upgrades = {
	"item": "owned",
}


func _ready() -> void:
	pass


#region - - SETTERS & GETTERS - - -
#
func _set_resourcePC(resource_type):
	var resource = Game.find_property(resource_type)
	if resource:
		var a = resource_type.slice(0,1)
		resource_type.erase(0,1)
		a.to_upper()
		a += resource_type
		resource = Game.find_property("base%s" % [resource_type])
	return resource


func _update_weaponsPC():
	weaponsPC = baseWeaponsPC
	# apply multipliers
	return weaponsPC


func _set_weaponsPS(value):
	# apply multipliers
	return

#endregion

extends Resource
class_name ItemTags


#@export_flags("a", "b") var tags
enum Tags { WEAPONPOWER, WEAPONS, UPGRADE }
#enum { WEAPONSPOWER, WEAPONS, UPGRADE }
enum InternalTags {}

## Manually set tags for sorting & filtering.
@export var taglist: Array[Tags] = []
# Automatically filled tags for internal use.
var internal_tags: Array = []


func _init() -> void:
	pass


func _auto_tag() -> void:

	pass

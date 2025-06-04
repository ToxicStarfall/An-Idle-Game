extends Resource
class_name ItemTags


#@export_flags("a", "b") var tags
enum Tags { WEAPONS, WEAPONPOWER, WEAPONPOWERE, UPGRADE, RESEARCH }
#enum { WEAPONSPOWER, WEAPONS, UPGRADE }
enum InternalTags {}

## Manually set tags for sorting & filtering.
@export var taglist: Array[Tags] = []
# Automatically filled tags for internal use.
var internal_tags: Array = []


func _init() -> void:
	pass


func auto_tag(item: Item):
	#internal_tags.append(w
		#item.get_script().get_global_name()
	#)  # add item tags
	for requirement in item.costs:
		internal_tags.append ( requirement.currency )
	for requirement in item.requirements:
		if requirement is RequirementCurrency:
			if !internal_tags.has( requirement.currency ):
				internal_tags.append ( requirement.currency )
		if requirement is RequirementItem:
			if !internal_tags.has( requirement.item.get_script().get_global_name() ):
				internal_tags.append ( requirement.item.get_script().get_global_name() )

	for i in internal_tags:
		internal_tags[ internal_tags.find(i) ] = i.to_upper()
	print(internal_tags)
	pass

extends Resource
class_name ItemTags


enum Tags {
	# Currencies
	#WEAPONS, WEAPONPOWER, WEAPONPOWERE,
	KNOWLEDGE, INSIGHT,
	POWER,
	# Items
	UPGRADE, RESEARCH, GENERATOR,
	# Misc
}
enum InternalTags {}

## Manually set tags for sorting & filtering.
@export var taglist: Array[Tags] = []
# Automatically filled tags for internal use.
var internal_tags: Array = []

## Tags to listen to for updates
var update_tags = []



#func auto_tag(item: Item):
	## Adds tags for [RequirementCost]
	#for requirement in item.costs:
		#internal_tags.append ( requirement.currency )
	## Adds tags for [Requirements]
	#for requirement in item.requirements:
		#if requirement is RequirementCurrency:
			#if !internal_tags.has( requirement.currency ):
				#internal_tags.append ( requirement.currency )
		#if requirement is RequirementItem:
			#if !internal_tags.has( requirement.item.get_script().get_global_name() ):
				#internal_tags.append ( requirement.item.get_script().get_global_name() )
#
	#for i in internal_tags:
		#internal_tags[ internal_tags.find(i) ] = i.to_upper()
	##print(internal_tags)
	#pass


## Automatically adds tags based on item's costs and requirements
func generate(item: Item):
	## Add tags from item costs' currency requirement
	for requirement in item.costs:
		internal_tags.append ( requirement.currency )
	## Add tags from item requirement's currency req
	for requirement in item.requirements:
		if requirement is RequirementCurrency:
			if !internal_tags.has( requirement.currency ):
				internal_tags.append ( requirement.currency )
		if requirement is RequirementItem:  # Add Item type tag
			if !internal_tags.has( requirement.item.get_script().get_global_name() ):
				internal_tags.append ( requirement.item.get_script().get_global_name() )

	for i in internal_tags:  # Capitalize tags
		internal_tags[ internal_tags.find(i) ] = i.to_upper()
	#print(internal_tags)
	pass

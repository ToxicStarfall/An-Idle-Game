extends Resource
class_name Currency

#enum { weaponPower, weaponPowerE }
enum Types {
	weaponPower,
	researchPower,
	organic,
	stone,
	metal,
}
@export var quantity: int = 0


#class weaon = Currency.new()
#class WeaponPower:
	#var material = true

	#pass

func add(value):
	quantity += value
	pass

func subtract(value):
	quantity -= value
	pass

## Generates currency
extends Item
class_name Generator


@export var quantity: int = 0

#@export var burst_mode: bool = false
@export var generate_currencies: Array = []
@export var generate_time: float = 1.0  # amount earned = (time / 20tps) * currency



func buy_generator(quantity):
	if state == State.LOCKED: print("This item is LOCKED.")
	#if state == State.OWNED: #owned:
		#print("You already own \"%s\"" % [self.name])
	if state == State.UNLOCKED: #not owned
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
			_set_state( State.OWNED )
			_apply_costs()
			_apply_effects()
			#self.text += "\nBought"
			# update
			print("Bought \"%s\" for {stuff}" % [self.name])
		else:
			print("Cannot buy. \"%s\" requires %s" % [self.name, _get_costs()])

func sell_generator(quantity):
	pass

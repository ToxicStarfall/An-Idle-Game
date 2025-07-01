## Generates currency
extends Item
class_name Generator


@export var quantity: int = 0
@export var progress: float = 0

#@export var burst_mode: bool = false
@export var generate_time: float = 1.0  # amount earned = (time / 20tps) * currency
@export var generate_currencies: Array[GeneratorEffect] = []

#@onready var generate_timer = get_tree().create_timer(1)


func buy_generator(amount: int):
	if state == State.LOCKED:  print("This item is LOCKED.")
	if state == State.UNLOCKED or state == State.OWNED:
		var valid = true
		# cancel purchase if a requirement is not met
		for requirement in requirements:
			if requirement.check() == false:
				valid = false
		for requirement in costs:
			if requirement.check() == false:
				valid = false

		if valid:
			self.quantity += amount
			_set_state( State.OWNED )
			print("Bought \"%s\" for %s" % [self.name, get_costs()])
			_apply_costs()
			_apply_effects()
			_scale_cost(1)
		else:
			print("Cannot buy. \"%s\" requires %s" % [self.name, get_costs()])


func sell_generator(_quantity):
	pass


func generate_currency():
	for generator_effect in generate_currencies:  # For every currency type,
		generator_effect.apply( quantity )        # generate each for every [Generator] owned


func _scale_cost(amount):
	#Game.get_property("generator_cost_scale")
	for i in costs:
		i.value *= (GameData.generator_cost_scale ** (quantity - 1))
		#print(i.value)
		pass
	pass

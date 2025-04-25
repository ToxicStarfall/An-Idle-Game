## Generates currency
extends Item
class_name Generator



@export var burst_mode: bool = false
@export var generate_currencies: Array = []
@export var generate_time: float = 1.0  # amount earned = (time / 20tps) * currency

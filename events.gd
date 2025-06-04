extends Node


# GENERIC DATA
signal resource_added( resource_name: String, amount_added: float )
signal resource_removed( resource_name: String, amount_removed: float )


# USER INTERFACE
signal weapon_power_changed

signal knowledge_changed( new_value )
#signal thought


signal requestTooltip

extends Node


@warning_ignore_start("UNUSED_SIGNAL")

# - - - Initialization - - - - #
signal user_interface_loaded

# - - - GENERIC DATA - - - - - #
signal resource_added( resource_name: String, amount_added: float )
signal resource_removed( resource_name: String, amount_removed: float )

signal item_state_changed( tag_name, new_state )  ## Updates items with tag
#signal item_bought( item: Item, item_node: ItemNode )
signal function_unlocked( node_name )     ## Unlocks the specified UI node (makes visible).
signal function_highlighted( node_name, stop_signal )  ## Highligts the specified UI node until clicked.

signal game_saved
signal game_loaded

# - - - USER INTERFACE - - - - #
#signal weapon_power_changed

# Updates thought logic
signal thought_progressed(meditate_active: bool)
#signal thought_completed
# Updates hought UI progress
signal ui_thought_progressed( new_progress )  # Per click vfx
signal ui_thought_completed( new_progress )   # Completion visual effects
signal thoughtProgressReq_changed( new_req )
signal thoughtEarn_changed

signal knowledge_changed(knowledge)
signal update_knowledge_counters( knowledge, knowledgeE )
signal update_power_counters( power, powerE )


#region - - - Events - - - - #
signal trigger_event( event: Event )

#endregion

signal request_tooltip( node, visbility: bool )


@warning_ignore_restore("UNUSED_SIGNAL")

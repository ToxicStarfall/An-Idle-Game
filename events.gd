extends Node


@warning_ignore_start("UNUSED_SIGNAL")

# - - - GENERIC DATA - - - - - #
signal resource_added( resource_name: String, amount_added: float )
signal resource_removed( resource_name: String, amount_removed: float )

signal item_state_changed( tag_name, new_state )  # Updates items with tag
#signal item_bought( item: Item, item_node: ItemNode )
signal function_unlocked( node_name )

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

signal update_knowledge_counters( knowledge, knowledgeE )
signal update_power_counters( power, powerE )


#signal new_event( event: Event )
signal trigger_event( event: Event )
signal message_logged( message: String, tooltip: Resource)
#signal event_option_selected()

signal request_tooltip( node, visbility: bool )


@warning_ignore_restore("UNUSED_SIGNAL")

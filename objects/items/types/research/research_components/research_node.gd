extends ItemNode
class_name ResearchNode


signal update_connector( researchNode: ResearchNode )


#func _ready() -> void:
	#super()
	#pass


func _update_state(state: Item.State):
	super(state)

	update_connector.emit( self )

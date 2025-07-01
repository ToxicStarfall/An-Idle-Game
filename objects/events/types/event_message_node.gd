class_name EventMessageNode
extends RichTextLabel


var event_data: Event


func _ready() -> void:
	meta_clicked.connect( _on_meta_clicked )
	meta_hover_started.connect( _on_meta_hover_started )
	meta_hover_ended.connect( _on_meta_hover_ended )



func _on_meta_clicked(_meta):
	pass


func _on_meta_hover_started(_meta):
	Events.request_tooltip.emit(self, event_data.tooltip_data, true)


func _on_meta_hover_ended(_meta):
	Events.request_tooltip.emit(self, event_data.tooltip_data, false)

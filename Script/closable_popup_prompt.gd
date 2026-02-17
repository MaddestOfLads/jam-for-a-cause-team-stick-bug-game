class_name ClosablePopupPrompt extends Control

signal popup_closed()

@export var _contents_box : MarginContainer = null
@export var _close_button_label : RichTextLabel = null


func _init() -> void:
	hide()

func set_contents(contents : PackedScene, close_button_text : String):
	if(contents):
		_contents_box.add_child(contents.instantiate())
	_close_button_label.text = close_button_text
	show()

func _on_start_button_pressed() -> void:
	popup_closed.emit()
	queue_free()

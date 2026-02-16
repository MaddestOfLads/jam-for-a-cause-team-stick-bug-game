class_name Ui extends Control


@export var race_name_label : Label = null
@export var race_description_label : Label = null
@export var race_image_texture_rect : TextureRect = null
@export var race_description_ui : Control = null
@export var popup_ui : Control = null
@export var popup_label : Label = null
@export var race_description_ui_position_offset : Vector2 = Vector2.ZERO
@export var race_description_ui_scale_multiplier : float = 1

var _prev_island: Island = null
var _curr_island : Island = null


func _ready() -> void:
	race_description_ui.hide()
	popup_ui.hide()

func set_details(island: Island) -> void:
	popup_ui.hide()
	if race_name_label and race_description_label and race_image_texture_rect:
		_curr_island = island
		race_name_label.text = RaceDb.get_race_name_as_text(island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(island.inhabiting_race)
		race_image_texture_rect.texture = RaceDb.RacePortraitDict[island.inhabiting_race]
		update_desc_ui_transforms()
		race_description_ui.show()
	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

func update_desc_ui_transforms():
	if _curr_island:
		race_description_ui.scale = _curr_island.get_global_transform_with_canvas().get_scale() * race_description_ui_scale_multiplier
		race_description_ui.position = _curr_island.get_global_transform_with_canvas().get_origin() + (race_description_ui_position_offset) * race_description_ui.scale

func _physics_process(delta: float) -> void:
	update_desc_ui_transforms()

# Displays details of starting drag island in UI
func prev_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDb.get_race_name_as_text(_prev_island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(_prev_island.inhabiting_race)
		race_image_texture_rect.texture = RaceDb.RacePortraitDict[_prev_island.inhabiting_race]
		race_description_ui.show()

func clear_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = ""
		race_description_label.text = ""
		race_image_texture_rect.texture = null
		race_description_ui.hide()
	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

func set_prev(island: Island) -> void:
	_prev_island = island

func show_popup(text : String):
	popup_label.text = text
	popup_ui.show()

class_name Ui extends Control


@export var race_name_label : RichTextLabel = null
@export var race_description_label : RichTextLabel = null
@export var race_image_texture_rect : TextureRect = null

var _prev_island: Island = null


func _ready() -> void:
	hide()

func set_details(island: Island) -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDb.get_race_name_as_text(island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(island.inhabiting_race)
		
		# TODO: FINALIZE WHEN TEXTURES AVAILABLE
		race_image_texture_rect.texture = null
		show()

	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

# Displays details of starting drag island in UI
func prev_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDb.get_race_name_as_text(_prev_island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(_prev_island.inhabiting_race)
		
		# TODO: FINALIZE WHEN TEXTURES AVAILABLE
		race_image_texture_rect.texture = null
		show()

func clear_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = ""
		race_description_label.text = ""
		race_image_texture_rect.texture = null
		hide()
	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

func set_prev(island: Island) -> void:
	_prev_island = island

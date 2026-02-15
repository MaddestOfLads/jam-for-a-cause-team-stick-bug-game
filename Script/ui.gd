class_name Ui extends Control


@export var race_name_label : RichTextLabel = null
@export var race_description_label : RichTextLabel = null
@export var race_image_texture_rect : TextureRect = null
@export var race_description_ui : Control = null
@export var popup_ui : Control = null
@export var popup_label : RichTextLabel = null

var _prev_island: Island = null


func _ready() -> void:
	race_description_ui.hide()
	popup_ui.hide()

func set_details(island: Island) -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDb.get_race_name_as_text(island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(island.inhabiting_race)
		
		# TODO: FINALIZE WHEN TEXTURES AVAILABLE
		race_image_texture_rect.texture = null
		race_description_ui.show()

	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

# Displays details of starting drag island in UI
func prev_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDb.get_race_name_as_text(_prev_island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(_prev_island.inhabiting_race)
		
		# TODO: FINALIZE WHEN TEXTURES AVAILABLE
		race_image_texture_rect.texture = null
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

func show_popup(race1 : RaceDB.Races, race2 : RaceDB.Races):
	popup_ui.show()
	# TODO: get text from DB, replace race_A and race_B in text with race names, and 
	return

func hide_popup():
	popup_ui.hide()
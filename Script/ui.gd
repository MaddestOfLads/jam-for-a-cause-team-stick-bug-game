class_name Ui extends Control


@export var race_name_label : RichTextLabel = null
@export var race_description_label : RichTextLabel = null
@export var race_image_texture_rect : TextureRect = null


func _ready() -> void:
	hide()

func set_details(race: RaceDB.Races, race_description: String, race_portrait: Texture2D) -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = RaceDB.RaceNameDict[race]
		# TODO: Replace these with DB lookups after loading .json as well to reduce risk of typos?
		race_description_label.text = race_description
		race_image_texture_rect.texture = race_portrait
		show()

	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")
		
func clear_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		race_name_label.text = ""
		race_description_label.text = ""
		race_image_texture_rect.texture = null
		hide()
	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

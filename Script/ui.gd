class_name Ui extends Control


@export_group("Race Preview")
@export_subgroup("References")
@export var race_name_label : Label = null
@export var race_description_label : Label = null
@export var race_image_texture_rect : TextureRect = null
@export var race_description_ui : Control = null

@export_subgroup("Configuration")
@export var race_description_ui_scale_multiplier : float = 1
@export var race_description_ui_position_offset_down : Vector2 = Vector2.ZERO
@export var race_description_ui_position_offset_up : Vector2 = Vector2.ZERO
@export var race_description_ui_position_offset_right : Vector2 = Vector2.ZERO
@export var race_description_ui_position_offset_left : Vector2 = Vector2.ZERO

@export_group("Popup")
@export_subgroup("References")
@export var popup_ui : Control = null
@export var popup_label : Label = null
@export var trait_label : Label = null
@export var hated_trait_label : Label = null

@export_group("Score")
@export_subgroup("References")
@export var connected_islands_score: RichTextLabel = null
@export var golden_bridges_score: RichTextLabel = null
const MAX_CONNECTED_ISLANDS: int = 27
const MAX_GOLDEN_BRIDGES: int = 14

var _prev_island: Island = null
var _curr_island : Island = null


func _ready() -> void:
	race_description_ui.hide()
	popup_ui.hide()
	update_connected_bridges(0)
	update_golden_bridges(0)

func set_details(island: Island) -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		_curr_island = island
		
		race_name_label.text = RaceDb.get_race_name_as_text(island.inhabiting_race)
		race_description_label.text = RaceDb.get_description(island.inhabiting_race)
		race_image_texture_rect.texture = RaceDb.RacePortraitDict[island.inhabiting_race]
		var traits : String = ""
		var hated_traits : String = ""
		for tag in RaceDb.get_expressed_tags(island.inhabiting_race):
			traits += "- " + tag + "\n"
		for tag in RaceDb.get_incompatible_tags(island.inhabiting_race):
			hated_traits += "- " + tag + "\n"

		trait_label.text = traits
		hated_trait_label.text = hated_traits

		update_desc_ui_transforms()
		race_description_ui.show()
	else:
		print("UI ERROR: NULL REFERENCE IN UI PROPERTIES")

func update_desc_ui_transforms():
	if _curr_island:
		race_description_ui.scale = _curr_island.get_global_transform_with_canvas().get_scale() * race_description_ui_scale_multiplier
		var pos_offset = race_description_ui_position_offset_down
		var screen_island_pos = (_curr_island.get_global_transform_with_canvas().get_origin() - get_viewport_rect().size/2)/ get_viewport_rect().size
		print(screen_island_pos)
		if(screen_island_pos.y > screen_island_pos.x):
			if(screen_island_pos.y > -screen_island_pos.x):
				pos_offset = race_description_ui_position_offset_up
			else:
				pos_offset = race_description_ui_position_offset_right
		else:
			if(screen_island_pos.y > -screen_island_pos.x):
				pos_offset = race_description_ui_position_offset_left
			else:
				pos_offset = race_description_ui_position_offset_down
		race_description_ui.position = _curr_island.get_global_transform_with_canvas().get_origin() + (pos_offset) * race_description_ui.scale

func _physics_process(delta: float) -> void:
	update_desc_ui_transforms()


# Displays details of starting drag island in UI
func prev_details() -> void:
	if race_name_label and race_description_label and race_image_texture_rect:
		
		set_details(_prev_island)

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

func update_connected_bridges(new_score: int) -> void:
	connected_islands_score.text = ": %s/%s" % [new_score, MAX_CONNECTED_ISLANDS]
	
func update_golden_bridges(new_score: int) -> void:
	golden_bridges_score.text = ": %s/%s" % [new_score, MAX_GOLDEN_BRIDGES]

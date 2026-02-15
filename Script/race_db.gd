class_name RaceDB extends Node


const _ISLAND_DATA_JSON = preload("res://island_data.json")

# Const json dict key refs
const _TAGS_AND_POPUPS = "tags_and_popups"
const _SPECIAL_TAGS = "special_tags"
const _RACES = "races"
const _DESCRIPTION = "Description"
const _EXPRESSED_TAGS = "Expressed tags"
const _INCOMPATIBLE_TAGS = "Incompatible tags"
const _NEEDED_CONNECTIONS = "Needed connections"

enum Races {
	Obskurs,
	Sparkies,
	Grumples,
	Tympanies,
	Bookworms,
	Sniffies,
	Partylooms,
	Zappyfunkies,
	Ews,
	Wooshywoosh,
	Perfeaus,
	Rigorins,
	Icyglops,
	Ferragons,
	Magmen,
	Swoopers,
	Goops,
	Gloops,
	Lazies,
	Joggernauts,
	Masozhops,
	Frewfrews,
	Paperies,
	Lovidovis,
	Pollies,
	Splats,
	Bloobs,
}

const RaceNameDict := {
	Races.Obskurs: "Obskurs",
	Races.Sparkies: "Sparkies",
	Races.Grumples: "Grumples",
	Races.Tympanies: "Tympanies",
	Races.Bookworms: "Bookworms",
	Races.Sniffies: "Sniffies",
	Races.Partylooms: "Partylooms",
	Races.Zappyfunkies: "Zappyfunkies",
	Races.Ews: "Ews",
	Races.Wooshywoosh: "Wooshywoosh",
	Races.Perfeaus: "Perfeaus",
	Races.Rigorins: "Rigorins",
	Races.Icyglops: "Icyglops",
	Races.Ferragons: "Ferragons",
	Races.Magmen: "Magmen",
	Races.Swoopers: "Swoopers",
	Races.Goops: "Goops",
	Races.Gloops: "Gloops",
	Races.Lazies: "Lazies",
	Races.Joggernauts: "Joggernauts",
	Races.Masozhops: "Masozhops",
	Races.Frewfrews: "Frewfrews",
	Races.Paperies: "Paperies",
	Races.Lovidovis: "Lovidovis",
	Races.Pollies: "Pollies",
	Races.Splats: "Splats",
	Races.Bloobs: "Bloobs",
}

class BridgeResult:
	var successful : bool
	var needed : bool
	var popup_dialogue : String
	func _init(_successful : bool, _needed : bool, _text : String) -> void:
		successful = _successful
		needed = _needed
		popup_dialogue = _text

var _island_data_variant: Variant = null
var _valid_tags: Dictionary


func _ready() -> void:
	_island_data_variant = _ISLAND_DATA_JSON.data
	_valid_tags = _island_data_variant[_TAGS_AND_POPUPS] as Dictionary
	_valid_tags.merge(_island_data_variant[_SPECIAL_TAGS] as Dictionary, true)
	validate_tags()

func get_race_name_as_text(race: Races) -> String:
	return RaceNameDict[race]

func get_description(race: Races) -> String:
	return _island_data_variant[_RACES][RaceNameDict[race]][_DESCRIPTION]

func get_expressed_tags(race: Races) -> Array:
	return _island_data_variant[_RACES][RaceNameDict[race]][_EXPRESSED_TAGS]

func get_incompatible_tags(race: Races) -> Array:
	return _island_data_variant[_RACES][RaceNameDict[race]][_INCOMPATIBLE_TAGS]

func validate_tags() -> void:
	var race_dict = _island_data_variant[_RACES]
	for race in race_dict:
		var tags = race_dict[race][_EXPRESSED_TAGS] + race_dict[race][_INCOMPATIBLE_TAGS]

		# Validate tags
		for tag in tags:
			if tag not in _valid_tags:
				assert(tag == "", "Tag '%s' is not a valid tag" % tag)

	for tag in _valid_tags:
		if tag not in _valid_tags:
			assert(tag == "", "Tag '%s' is not a valid tag" % tag)

func get_bridge_result(race_1 : Races, race_2 : Races) -> BridgeResult:

	# 1. check for needed connections:
	var needed_connections = _island_data_variant[_NEEDED_CONNECTIONS]
	for i in range(needed_connections):
		if (needed_connections[i][0] == RaceNameDict[race_1] and needed_connections[i][1] == RaceNameDict[race_2]) or (needed_connections[i][0] == RaceNameDict[race_2] and needed_connections[i][1] == RaceNameDict[race_1]):
			return BridgeResult.new(needed_connections[i][2], true, needed_connections[i][3])

	# 2. check for tag incompatibilities:
	var expressed_tags_1 : Array[String] = get_expressed_tags(race_1)
	var expressed_tags_2 : Array[String] = get_expressed_tags(race_2)
	var incompatible_tags_1 : Array[String] = get_incompatible_tags(race_1)
	var incompatible_tags_2 : Array[String] = get_incompatible_tags(race_2)
	for i in range(expressed_tags_1):
		for j in range(incompatible_tags_2):
			if expressed_tags_1[i] == incompatible_tags_2[i]:
				return BridgeResult.new(false, false, "") # TODO: add interaction text and replace race names
	for i in range(expressed_tags_2):
		for j in range(incompatible_tags_1):
			if expressed_tags_2[i] == incompatible_tags_1[i]:
				return BridgeResult.new(false, false, "") # TODO: add interaction text and replace race names

	# 3. fallback to positive connection with no description
	return BridgeResult.new(true, false, "")

func replace_race_names(text : String, offending_race : Races, offended_race : Races) -> String:
	return text.replace("race_A", RaceNameDict[offended_race]).replace("race_B", RaceNameDict[offending_race])
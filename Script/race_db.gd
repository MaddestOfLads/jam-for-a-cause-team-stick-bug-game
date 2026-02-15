class_name RaceDB extends Node


const _ISLAND_DATA_JSON = preload("res://island_data.json")

# Const json dict key refs
const _TAGS_AND_POPUPS = "tags_and_popups"
const _SPECIAL_TAGS = "special_tags"
const _RACES = "races"
const _DESCRIPTION = "Description"
const _EXPRESSED_TAGS = "Expressed tags"
const _INCOMPATIBLE_TAGS = "Incompatible tags"

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

class_name RaceDB extends Node


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

@export var _island_data: JSON = null
var _island_data_variant: Variant = null


func _ready() -> void:
	_island_data_variant = _island_data.data

func get_race_description(race: Races) -> String:
	if _island_data_variant:
		return _island_data_variant[_RACES][RaceNameDict[race]][_DESCRIPTION]
		
	else:
		print("ISLAND DATA NOT INITIALIZED")
		return ""

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
	Races.Masozhops: "Masozchops",
	Races.Frewfrews: "Frewfrews",
	Races.Paperies: "Paperies",
	Races.Lovidovis: "Lovidovis",
	Races.Pollies: "Pollies",
	Races.Splats: "Splats",
	Races.Bloobs: "Bloobs",
}

const RacePortraitDict := {
	Races.Obskurs: preload("uid://doneengny72nr"),
	Races.Sparkies: preload("uid://bvux8o1f82syn"),
	Races.Grumples: null,
	Races.Tympanies: preload("uid://bh20m83qu65y2"),
	Races.Bookworms: preload("uid://co7cwxmhp32et"),
	Races.Sniffies: null,
	Races.Partylooms: preload("uid://b5cn6pjqo6vyi"),
	Races.Zappyfunkies: preload("uid://br2ttpu7wvbof"),
	Races.Ews: preload("uid://3v0j1vs58b8r"),
	Races.Wooshywoosh: null,
	Races.Perfeaus: null,
	Races.Rigorins: preload("uid://dgvvdmgj470ej"),
	Races.Icyglops: preload("uid://cqkkkgseglpnl"),
	Races.Ferragons: null,
	Races.Magmen: preload("uid://dgu5hbhbauce2"),
	Races.Swoopers: null,
	Races.Goops: preload("uid://c4w0fh58boqce"),
	Races.Gloops: null,
	Races.Lazies: null,
	Races.Joggernauts: null,
	Races.Masozhops: preload("uid://ch1iou6tqhfaf"),
	Races.Frewfrews: null,
	Races.Paperies: preload("uid://bnl7jlfqcpr0s"),
	Races.Lovidovis: null,
	Races.Pollies: preload("uid://cmun5sjj0trgj"),
	Races.Splats: null,
	Races.Bloobs: preload("uid://lhc3h8o7afbl")
}

const IslandSpriteDict := {
	Races.Obskurs: preload("uid://bkxca4f7agaiu"),
	Races.Sparkies: preload("uid://bc5nkjkn3k51v"),
	Races.Grumples: preload("uid://cj6eeikuimil8"),
	Races.Tympanies: preload("uid://bpcvnf3an3auh"),
	Races.Bookworms: preload("uid://ds8dr05qahplu"),
	Races.Sniffies: preload("uid://dys6oix7kiu8p"),
	Races.Partylooms: preload("uid://cyqb7uphp3cvl"),
	Races.Zappyfunkies: preload("uid://el7txdcpw6t0"),
	Races.Ews: preload("uid://bdaj6ugnkftc7"),
	Races.Wooshywoosh: preload("uid://cwty6snde2qck"),
	Races.Perfeaus: preload("uid://dcuc5c23b6v6s"),
	Races.Rigorins: preload("uid://1rgtpx6u7x3d"),
	Races.Icyglops: preload("uid://dedeax44w0k7"),
	Races.Ferragons: preload("uid://cfsuh5ajtyk3n"),
	Races.Magmen: preload("uid://mn8qap4u4g5s"),
	Races.Swoopers: preload("uid://bvx7a5bu6bkm"),
	Races.Goops: preload("uid://fx5aic4glyvj"),
	Races.Gloops: preload("uid://cuem7sce6lf64"),
	Races.Lazies: preload("uid://bnf5k2aliv5b1"),
	Races.Joggernauts: preload("uid://dd2yorf33idg"),
	Races.Masozhops: preload("uid://q5ajphlg6qy1"),
	Races.Frewfrews: preload("uid://bf5dnou6wcnbi"),
	Races.Paperies: preload("uid://cr6e1fbsu1fxr"),
	Races.Lovidovis: preload("uid://tavscoat0a0g"),
	Races.Pollies: preload("uid://blwlsxmdx2vgp"),
	Races.Splats: preload("uid://c6i4fmfa3bba0"),
	Races.Bloobs: preload("uid://xinhoyh5puy")
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
var _tags_and_popups: Dictionary


func _ready() -> void:
	_island_data_variant = _ISLAND_DATA_JSON.data
	
	_tags_and_popups = _island_data_variant[_TAGS_AND_POPUPS] as Dictionary
	_tags_and_popups.merge(_island_data_variant[_SPECIAL_TAGS] as Dictionary, true)
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
			if tag not in _tags_and_popups:
				assert(tag == "", "Tag '%s' is not a valid tag" % tag)

func get_bridge_result(race_1 : Races, race_2 : Races) -> BridgeResult:
	# 1. check for needed connections:
	var needed_connections = _island_data_variant[_NEEDED_CONNECTIONS]
	for connection in needed_connections:
		if (connection[0] == RaceNameDict[race_1] and connection[1] == RaceNameDict[race_2]) or (connection[0] == RaceNameDict[race_2] and connection[1] == RaceNameDict[race_1]):
			return BridgeResult.new(connection[2], true, connection[3])

	# 2. check for tag incompatibilities:
	var expressed_tags_1 : Array = get_expressed_tags(race_1)
	var expressed_tags_2 : Array = get_expressed_tags(race_2)
	var incompatible_tags_1 : Array = get_incompatible_tags(race_1)
	var incompatible_tags_2 : Array = get_incompatible_tags(race_2)
	
	for tag in expressed_tags_1:
		if tag in incompatible_tags_2:
			var popup = _tags_and_popups[tag]
			return BridgeResult.new(false, false, replace_race_names(popup, race_1, race_2))

	for tag in expressed_tags_2:
		if tag in incompatible_tags_1:
			var popup = _tags_and_popups[tag]
			return BridgeResult.new(false, false, replace_race_names(popup, race_2, race_1))

	# 3. fallback to positive connection with no description
	return BridgeResult.new(true, false, "")

func replace_race_names(text : String, offending_race : Races, offended_race : Races) -> String:
	return text.replace("race_A", RaceNameDict[offended_race]).replace("race_B", RaceNameDict[offending_race])

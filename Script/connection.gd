class_name NeededConnection extends Resource


var _island_1_id: int = -1
var _island_2_id: int = -1
var _is_connection_successful: bool = false
var _interaction_flavor_text: String = ""

func _init(island_1_id : int, island_2_id : int, is_connection_successful : bool, interaction_flavor_text : String) -> void:
	self._island_1_id = island_1_id
	self._island_2_id = island_2_id
	self._is_connection_successful = is_connection_successful
	self._interaction_flavor_text = interaction_flavor_text

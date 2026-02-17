class_name Island extends Area2D


@export var inhabiting_race: RaceDB.Races
@export var radius_circle : RadiusCircle = null
@export var base_radius : int = 3
@export var sprite : Sprite2D = null


const RADIUS_MULTIPLIER : int = 200

var _default_modulate : Color = Color(1.0, 1.0, 1.0)
var _hovered_modulate : Color = Color(1.5, 1.5, 1.5)

# Signals to wrap the built-in signals mouse_entered and mouse_exited inside custom signals, because these signals have no arguments by default and we also need to pass a reference to the hovered/unhovered island.
signal island_hovered(island)
signal island_no_longer_hovered(island)

var connected_bridges : Array[Bridge] = []

func update_radius_circle():
	radius_circle.radius = get_effective_radius()

func _ready() -> void:
	radius_circle.radius = get_effective_radius()
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	modulate = _default_modulate
	sprite.texture = RaceDb.IslandSpriteDict[inhabiting_race]

func on_mouse_entered():
	modulate = _hovered_modulate
	radius_circle.show()
	island_hovered.emit(self)

func on_mouse_exited():
	modulate = _default_modulate
	radius_circle.hide()
	island_no_longer_hovered.emit()

func add_bridge(bridge : Bridge):
	connected_bridges.append(bridge)
	update_radius_circle()

func remove_bridge(bridge : Bridge):
	for i in range(connected_bridges.size()):
		if (connected_bridges[i] == bridge):
			connected_bridges.remove_at(i)
			break
	update_radius_circle()

func is_other_island_already_connected(other : Island) -> bool:
	for i in range(connected_bridges.size()):
		if (connected_bridges[i].island_1 == other or self.connected_bridges[i].island_2 == other):
			return true
	return false

func get_effective_radius() -> int:
	return (base_radius + connected_bridges.size()) * RADIUS_MULTIPLIER

func is_other_island_within_range(other : Island) -> bool:
	var dist = position.distance_to(other.position)
	return (dist <= get_effective_radius() and dist <= other.get_effective_radius())

func get_neighbours() -> Array[Island]:
	var islands : Array[Island] = []
	for bridge in connected_bridges:
		if self == bridge.island_1 and bridge.island_2 != null:
			islands.append(bridge.island_2)
		elif self == bridge.island_2 and bridge.island_1 != null:
			islands.append(bridge.island_1)
	return islands

func get_connected_islands(already_connected : Array[Island], already_visited : Array[Island]) -> Array[Island]:
	if self not in already_visited:
		already_visited.append(self)
	if self not in already_connected:
		already_connected.append(self)
		for neighbour in get_neighbours():
			if neighbour not in already_visited:
				neighbour.get_connected_islands(already_connected, already_visited)
	return already_connected

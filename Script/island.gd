class_name Island extends Area2D


@export var id: int = -1
@export var radius_circle : RadiusCircle = null
@export var base_radius : int = 5

const RADIUS_MULTIPLIER : int = 200

var _default_modulate : Color = Color(1.0, 1.0, 1.0)
var _hovered_modulate : Color = Color(1.5, 1.5, 1.5)

# Signals to wrap the built-in signals mouse_entered and mouse_exited inside custom signals, because these signals have no arguments by default and we also need to pass a reference to the hovered/unhovered island.
signal island_hovered(island)
signal island_no_longer_hovered(island)

var connected_bridges : Array[Bridge] = []

func _ready() -> void:
	radius_circle.radius = effective_radius()
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	modulate = _default_modulate

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

func remove_bridge(bridge : Bridge):
	for i in range(connected_bridges.size()):
		if (connected_bridges[i] == bridge):
			connected_bridges.remove_at(i)
			break

func is_other_island_already_connected(other : Island) -> bool:
	for i in range(connected_bridges.size()):
		if (connected_bridges[i].island_1 == other or self.connected_bridges[i].island_2 == other):
			return true
	return false

func effective_radius() -> int:
	return (base_radius + connected_bridges.size()) * RADIUS_MULTIPLIER

func is_other_island_within_range(other : Island) -> bool:
	var dist = position.distance_to(other.position)
	return (dist <= effective_radius() and dist <= other.effective_radius())
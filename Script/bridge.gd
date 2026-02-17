class_name Bridge extends Area2D


var island_1: Island = null
var island_2: Island = null
var is_golden: bool = false

var _default_modulate : Color = Color(1.0, 1.0, 1.0, 1.0)
var _preview_modulate : Color = Color(1.0, 1.0, 0.0, 1.0)
var _hovered_modulate : Color = Color(1.0, 0.0, 0.0, 1.0)

const BRIDGE_TEXTURE = preload("uid://c4a1sy40b1bl3")
const GOLD_BRIDGE_TEXTURE = preload("uid://bnprr2gi6rkrn")

@export var line_collider: CollisionShape2D = null
var line: Line2D = null
const COLLIDER_PADDING: int = 6

signal bridge_hovered(bridge)
signal bridge_unhovered(bridge)

signal bridge_built(golden)
signal bridge_burnt(golden)


func _init() -> void:
	line = Line2D.new()
	line.texture_mode = Line2D.LineTextureMode.LINE_TEXTURE_TILE
	line.width = 32
	line.add_point(Vector2.ZERO)
	line.add_point(Vector2.ZERO)
	add_child(line)
	modulate = _default_modulate

func on_mouse_entered() -> void:
	modulate = _hovered_modulate
	bridge_hovered.emit(self)

func on_mouse_exited() -> void:
	modulate = _default_modulate
	bridge_unhovered.emit()

func start_bridge_preview(start_island : Island) -> void:
	modulate = _preview_modulate
	island_1 = start_island
	set_ends(start_island.position, start_island.position)

func try_build_bridge(end_island: Island) -> RaceDb.BridgeResult:
	if(island_1 == end_island):
		return null
	island_2 = end_island

	var attempt_result = RaceDb.get_bridge_result(island_1.inhabiting_race, island_2.inhabiting_race)
	if attempt_result.successful:
		build_bridge()
		is_golden = attempt_result.needed
		
		set_bridge_texture(is_golden)
		bridge_built.emit(is_golden)

	else:
		queue_free()

	return attempt_result

func build_bridge() -> void:
	set_ends_to_islands()
	island_1.add_bridge(self)
	island_2.add_bridge(self)
	resize_collider()

	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)

	modulate = _default_modulate

func set_bridge_texture(golden : bool = false):
	if line:
		if golden:
			line.texture = GOLD_BRIDGE_TEXTURE
		else:
			line.texture = BRIDGE_TEXTURE

func burn_bridge() -> void:
	if (island_1 != null):
		island_1.remove_bridge(self)
	if (island_2 != null):
		island_2.remove_bridge(self)

	bridge_burnt.emit(is_golden)
	queue_free()

func set_ends(start : Vector2, end : Vector2):
	if (start != null):
		line.points[0] = start
	if (end != null):
		line.points[1] = end

func set_ends_to_islands():
	if (island_1 != null):
		line.points[0] = island_1.position
	if (island_2 != null):
		line.points[1] = island_2.position

func resize_collider() -> void:
	line_collider.position = (line.points[0] + line.points[1]) / 2
	line_collider.rotation = line.points[0].direction_to(line.points[1]).angle()

	var length = line.points[0].distance_to(line.points[1])
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, line.width + COLLIDER_PADDING)
	line_collider.shape = rect
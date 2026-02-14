class_name Bridge extends Line2D

var island_1: Island = null
var island_2: Island = null

var _default_modulate : Color = Color(0.97, 0.388, 1.0, 1.0)
var _hovered_modulate : Color = Color(1.0, 0.5, 0.5)

@export var line_collider: CollisionShape2D = null
const COLLIDER_PADDING: int = 4

signal bridge_hovered(bridge)
signal bridge_unhovered(bridge)


func _init() -> void:
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)
	modulate = _default_modulate

#func build(start_island: Island, end_island: Island) -> Bridge:
	#if(start_island == end_island):
		#return null
#
	#island_1 = start_island
	#island_2 = end_island
#
	#set_ends_to_islands()
	#island_1.add_bridge(self)
	#island_2.add_bridge(self)
	#resize_collider()
#
	## TODO: change color to normal color
	#return self

func start_bridging(start_island : Island):
	island_1 = start_island
	set_ends(start_island.position, start_island.position)
	# TODO: change color to "bridging" color
	
func burn_bridge() -> void:
	if (island_1 != null):
		island_1.remove_bridge(self)
	if (island_2 != null):
		island_2.remove_bridge(self)
	
	queue_free()

func set_ends(start : Vector2, end : Vector2):
	if (start != null):
		points[0] = start
	if (end != null):
		points[1] = end

func set_ends_to_islands():
	if (island_1 != null):
		points[0] = island_1.position
	if (island_2 != null):
		points[1] = island_2.position
		
func resize_collider() -> void:
	line_collider.position = (points[0] + points[1]) / 2
	line_collider.rotation = points[0].direction_to(points[1]).angle()
	
	var length = points[0].distance_to(points[1])
	var rect = RectangleShape2D.new()
	rect.size = Vector2(length, width + COLLIDER_PADDING)
	line_collider.shape = rect

func _on_area_2d_mouse_entered() -> void:
	modulate = _hovered_modulate
	bridge_hovered.emit(self)

func _on_area_2d_mouse_exited() -> void:
	modulate = _default_modulate
	bridge_unhovered.emit()

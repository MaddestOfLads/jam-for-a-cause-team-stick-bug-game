class_name Bridge extends Line2D


var island_1: Island = null
var island_2: Island = null

func _init() -> void:
	add_point(Vector2.ZERO)
	add_point(Vector2.ZERO)

func build(start_island: Island, end_island: Island) -> Bridge:
	if(start_island == end_island):
		return null

	island_1 = start_island
	island_2 = end_island

	set_ends(island_1.position, island_2.position)
	# TODO: change color to normal color
	return self

func start_bridging(start_island : Island):
	island_1 = start_island
	set_ends(start_island.position, start_island.position)
	# TODO: change color to "bridging" color
	return

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

class_name Bridge extends Line2D


var _island_1: Island = null
var _island_2: Island = null

func _init() -> void:
	self.add_point(Vector2.ZERO)
	self.add_point(Vector2.ZERO)

func build(island_1: Island, island_2: Island) -> Bridge:
	self._island_1 = island_1
	self._island_2 = island_2

	self.points[0] = _island_1.position
	self.points[1] = _island_2.position

	return self

func preview(island_1 : Island, cursor_pos : Vector2):
	self.points[0] = island_1.position
	self.points[1] = cursor_pos
	return

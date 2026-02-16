class_name Rocks extends Line2D

func _init() -> void:
	visible = false

func does_line_cross_rocks(start : Vector2, end : Vector2) -> bool:
	if (points.size() <= 1):
		return false
	for i in range(points.size() - 1):
		var b1 = points[i] + position
		var b2 = points[i+1] + position
		if(Geometry2D.segment_intersects_segment(start, end, b1, b2)):
			return true
	return false
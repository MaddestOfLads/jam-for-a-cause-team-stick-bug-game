class_name RadiusCircle extends Node2D

var radius : int = 500
var outline_color : Color = Color(0.5, 0.5, 1.0, 0.2)

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, outline_color)
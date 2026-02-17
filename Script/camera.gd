extends Camera2D


# Camera zoom
var _target_zoom: float = 0.8
@export var _zoom_speed: float = 8.0
@export var _zoom_increment: float = 0.1
@export var _max_zoom: float = 1
@export var _min_zoom: float = 0.3


func _physics_process(delta: float) -> void:
	if (not is_equal_approx(zoom.x, _target_zoom)): # Changed from set_physics_process() to an if statement because disabling physics process is generally not recommended if it isn't needed (cause physics_process often gets additional functionality down the line and disabling it can mess things up later if you want to add more stuff to it)
		zoom = lerp(zoom, _target_zoom * Vector2.ONE, _zoom_speed * delta)
	if position.x <= limit_left: position.x = limit_left
	if position.x >= limit_right: position.x = limit_right
	if position.y >= limit_bottom: position.y = limit_bottom
	if position.y <= limit_top: position.y = limit_top

# Moved zoom/pan logic to map.gd because dragging from an island shouldn't pan the camera,
# and it would be hard to implement this in the camera's script without breaking "call down signal up" rule.

func zoom_in() -> void:
	_target_zoom = clamp(_target_zoom - _zoom_increment, _min_zoom, _max_zoom)

func zoom_out() -> void:
	_target_zoom = clamp(_target_zoom + _zoom_increment, _min_zoom, _max_zoom)

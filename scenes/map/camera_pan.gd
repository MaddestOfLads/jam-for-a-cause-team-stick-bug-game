extends Camera2D


# Camera zoom
const _ZOOM_SPEED: float = 8.0
const _ZOOM_INCREMENT: float = 0.1

var _target_zoom: float = 1.0
var _max_zoom: float = 1.0
var _min_zoom: float = 0.1


func _physics_process(delta: float) -> void:
	zoom = lerp(zoom, _target_zoom * Vector2.ONE, _ZOOM_SPEED * delta)
	set_physics_process(not is_equal_approx(zoom.x, _target_zoom))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			position -= event.relative / zoom

	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_out()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_in()

func zoom_in() -> void:
	_target_zoom = clamp(_target_zoom - _ZOOM_INCREMENT, _min_zoom, _max_zoom)
	set_physics_process(true)

func zoom_out() -> void:
	_target_zoom = clamp(_target_zoom + _ZOOM_INCREMENT, _min_zoom, _max_zoom)
	set_physics_process(true)

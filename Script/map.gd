class_name Map extends Node2D


const _BRIDGE = preload("uid://bbfrx0mxarvxs")

@export var connection_array: Array[Connection] = []
@export var camera : Camera2D = null
@export var ui: Ui = null
@export var island_and_bridge_root : Node = null

var _drawn_bridge : Bridge = null # Bridge that is currently being drawn; null if no bridge is being drawn.

var _mouse_query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
var _mouse_intersections: Array = []
var _hovered_entity: Node = null
var _prev_hovered_entity : Node = null
var _drag_start_entity: Node = null
var _drag_end_entity: Node = null
var _is_dragging: bool = false


#func _ready() -> void:
	## TODO: Move to island_and_bridge_root.gd?
	#for node in island_and_bridge_root.get_children():
		#if node is Island:
			#node.island_hovered.connect(ui.set_details)
			#node.island_no_longer_hovered.connect(ui.clear_details)


func _unhandled_input(event: InputEvent) -> void:
	'''
	For mouse movement:
		- Queries intersection with pointer, gets current hovered entity with max Z Index
		- If mouse is unclicked and there's a bridge being drawn, stop drawing bridge
		- If mouse is clicked:
			- If a bridge is already being drawn, move end of the bridge
			- Otherwise, if an island is hovered, and mouse was JUST clicked, start drawing bridge
			- Otherwise, pan the camera
	
	For mouse:
		- If left clicking while hovering a bridge, delete bridge
		- If scroll up, zoom out
		- If scroll down, zoom in
	'''

	if event is InputEventMouseMotion:
		_prev_hovered_entity = _hovered_entity
		_hovered_entity = get_hovered_entity()

		if (not Input.is_action_pressed("left_click") and _drawn_bridge != null):
			_drag_end_entity = _hovered_entity
			ui.clear_details()
			stop_drawing_bridge()

		elif Input.is_action_pressed("left_click"):
			if (_drawn_bridge != null):
				_drawn_bridge.line.points[1] += (event.relative / camera.zoom)

				if _hovered_entity == null:
					ui.prev_details()

				elif _hovered_entity is Island and _hovered_entity != _drag_start_entity:
					ui.set_details(_hovered_entity)

			elif _hovered_entity is Island:
				start_drawing_bridge(_hovered_entity)
				_drag_start_entity = _hovered_entity
				ui.set_details(_hovered_entity)

			else:
				camera.position -= event.relative / camera.zoom

		else:
			if _hovered_entity == null:
				ui.clear_details()

			elif _hovered_entity is Island and _prev_hovered_entity == null:
				ui.set_details(_hovered_entity)


	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_LEFT and _hovered_entity is Bridge:
				_hovered_entity.burn_bridge()

			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom_out()

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom_in()

func start_drawing_bridge(start_island : Island) -> void:
	_drawn_bridge = _BRIDGE.instantiate()
	_drawn_bridge.start_bridge_preview(start_island)
	island_and_bridge_root.add_child(_drawn_bridge)
	ui.set_prev(start_island)

func stop_drawing_bridge() -> void:
	if (_hovered_entity == null or not _hovered_entity is Island) and _drawn_bridge != null:
		print("Bridge failed!")
		_drawn_bridge.queue_free()
	elif (_hovered_entity is Island and _hovered_entity == _drawn_bridge.island_1):
		print("Can't bridge an island to itself!")
		_drawn_bridge.queue_free()
		ui.show_popup("Can't bridge an island to itself!")
		pass
	elif (_hovered_entity is Island and _hovered_entity.is_other_island_already_connected(_drawn_bridge.island_1)):
		print("Island already connected!")
		ui.show_popup("Island already connected!")
		_drawn_bridge.queue_free()
		pass
	else:
		_drawn_bridge.try_build_bridge(_hovered_entity)
	
	_drawn_bridge = null
	_drag_start_entity = null
	_drag_end_entity = null

	ui.clear_details()

# Returns top-most hovered collider by Z Index
func get_hovered_entity() -> Node:
	_mouse_query.position = get_global_mouse_position()
	_mouse_query.collide_with_areas = true
	_mouse_intersections = get_world_2d().direct_space_state.intersect_point(_mouse_query)
	_mouse_intersections.sort_custom(func(a, b): return a["collider"].z_index > b["collider"].z_index)
	
	if _mouse_intersections.size() > 0:
		return _mouse_intersections[0]["collider"]

	return null
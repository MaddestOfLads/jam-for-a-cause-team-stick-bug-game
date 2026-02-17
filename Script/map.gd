class_name Map extends Node2D


const _BRIDGE = preload("uid://bbfrx0mxarvxs")

const _POPUP_PROMPT : PackedScene = preload("uid://dawwj2o4877c0")
const _VICTORY_CONTENTS : PackedScene = preload("uid://6hoftk26cgvr")
const _VICTORY_BUTTON_TEXT : String = "Cool!"


@export var camera : Camera2D = null
@export var ui: Ui = null
@export var island_and_bridge_root : Node = null

var connected_bridges: int = 0
var golden_bridges: int = 0

var _drawn_bridge : Bridge = null # Bridge that is currently being drawn; null if no bridge is being drawn.

var _mouse_query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
var _mouse_intersections: Array = []
var _hovered_entity: Node = null
var _prev_hovered_entity : Node = null
var _drag_start_entity: Node = null
var _drag_end_entity: Node = null

var _is_popup_present : bool = false

#func _ready() -> void:
	#popup(_VICTORY_CONTENTS, _VICTORY_BUTTON_TEXT) << HOW TO USE POPUPS

func _on_popup_closed() -> void:
	_is_popup_present = false

func popup(contents : PackedScene, button_text : String):
	var popup_prompt : ClosablePopupPrompt = _POPUP_PROMPT.instantiate()
	add_child(popup_prompt)
	_is_popup_present = true
	popup_prompt.popup_closed.connect(_on_popup_closed)
	popup_prompt.set_contents(contents, button_text)

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
	if(_is_popup_present):
		return	

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

				if(does_bridge_cross_rocks(_drawn_bridge)):
					_drawn_bridge.modulate = _drawn_bridge._hovered_modulate
				else:
					_drawn_bridge.modulate = _drawn_bridge._preview_modulate

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
	_drawn_bridge.bridge_built.connect(_on_bridge_built)
	_drawn_bridge.bridge_burnt.connect(_on_bridge_burnt)
	island_and_bridge_root.add_child(_drawn_bridge)
	ui.set_prev(start_island)
	ui.popup_ui.hide()

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
		
	else:
		if(does_bridge_cross_rocks(_drawn_bridge)):
			ui.show_popup("Can't bridge through rocks!")
			return

		var attempt_result = _drawn_bridge.try_build_bridge(_hovered_entity)
		if (attempt_result.popup_dialogue != ""):
			ui.show_popup(attempt_result.popup_dialogue)

		print("%s: %s" % [attempt_result.successful, attempt_result.popup_dialogue])

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

func does_bridge_cross_rocks(bridge : Bridge) -> bool:
	var children = island_and_bridge_root.get_children()
	for i in (children.size()):
		if children[i] is Rocks:
			if (children[i].does_line_cross_rocks(bridge.line.points[0], bridge.line.points[1])):
				return true
	return false

func _on_bridge_built(is_golden: bool) -> void:
	if is_golden:
		golden_bridges += 1
		ui.update_golden_bridges(golden_bridges)
	else:
		connected_bridges += 1
		ui.update_connected_bridges(get_max_cluster_size())

func _on_bridge_burnt(is_golden: bool) -> void:
	if is_golden:
		golden_bridges -= 1
		ui.update_golden_bridges(golden_bridges)
	else:
		connected_bridges -= 1
		ui.update_connected_bridges(get_max_cluster_size())

func get_max_cluster_size() -> int:
	var biggest_so_far = 0
	for child in island_and_bridge_root.get_children():
		if child is Island:
			var arr1 : Array[Island] = []
			var arr2 : Array[Island] = []
			biggest_so_far = max(biggest_so_far, child.get_connected_islands(arr1, arr2).size())
	return biggest_so_far

class_name Map extends Node2D


const _BRIDGE = preload("uid://bbfrx0mxarvxs")

@export var connection_array: Array[Connection] = []
@export var camera : Camera2D = null
@export var island_and_bridge_root : Node = null
@export var _test_island_1: Island = null
@export var _test_island_2: Island = null
@export var _test_island_3: Island = null

var _hovered_island : Island = null # Used for drawing bridges; updated through signals emited by islands
var _drawn_bridge : Bridge = null # Bridge that is currently being drawn; null if no bridge is being drawn.

func _ready() -> void:
	connect_island_signals()
	# spawn_test_bridges()

func connect_island_signals():
	for child : Node in island_and_bridge_root.get_children():
		if child is Island:
			child.island_hovered.connect(on_island_hovered)
			child.island_no_longer_hovered.connect(on_island_no_longer_hovered)

func spawn_test_bridges():
	var test_bridge = (_BRIDGE.instantiate() as Bridge).build(_test_island_1, _test_island_2)
	add_child(test_bridge)
	var test_bridge_2 = (_BRIDGE.instantiate() as Bridge).build(_test_island_2, _test_island_3)
	add_child(test_bridge_2)

func _unhandled_input(event: InputEvent) -> void:
	'''
	For mouse movement:
		- If mouse is unclicked and there's a bridge being drawn, stop drawing bridge
		- If mouse is clicked:
			- If a bridge is already being drawn, move end of the bridge
			- Otherwise, if an island is hovered, and mouse was JUST clicked, start drawing bridge
			- Otherwise, pan the camera
	
	For mouse click:
		- If scroll up, zoom out
		- If scroll down, zoom in
	'''

	if event is InputEventMouseMotion:
		if (not Input.is_action_pressed("left_click") and _drawn_bridge != null):
			stop_drawing_bridge(_hovered_island)

		elif Input.is_action_pressed("left_click"):
			if (_drawn_bridge != null):
				_drawn_bridge.points[1] += event.relative / camera.zoom
			elif (_hovered_island != null):
				start_drawing_bridge(_hovered_island)
			else:
				camera.position -= event.relative / camera.zoom
	
	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom_out()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom_in()

func on_island_hovered(island : Island):
	_hovered_island = island

func on_island_no_longer_hovered():
	_hovered_island = null

func start_drawing_bridge(start_island : Island):
	_drawn_bridge = _BRIDGE.instantiate()
	_drawn_bridge.start_bridging(start_island)
	island_and_bridge_root.add_child(_drawn_bridge)
	return

func stop_drawing_bridge(end_island : Island):
	if (end_island == null && _drawn_bridge != null):
		print("Bridge failed!")
		_drawn_bridge.queue_free()
	elif (end_island == _drawn_bridge.island_1):
		print("Can't bridge an island to itself!")
		pass # TODO: show a "same island" popup
	elif(end_island.is_other_island_already_connected(_drawn_bridge.island_1)):
		print("Island already connected!")
		pass # TODO: show an "island already connected" popup
	else:
		_drawn_bridge.island_2 = end_island
		_drawn_bridge.set_ends_to_islands()
	_drawn_bridge = null

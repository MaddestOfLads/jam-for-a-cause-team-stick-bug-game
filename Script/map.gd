class_name Map extends Node2D


const _BRIDGE = preload("uid://bbfrx0mxarvxs")

@export var connection_array: Array[Connection] = []
@export var camera : Camera2D = null
@export var island_and_bridge_root : Node = null

var _hovered_island : Island = null # Used for drawing bridges; updated through signals emited by islands
var _hovered_bridge: Bridge = null
var _drawn_bridge : Bridge = null # Bridge that is currently being drawn; null if no bridge is being drawn.


func _ready() -> void:
	connect_island_signals()

func connect_island_signals():
	for child : Node in island_and_bridge_root.get_children():
		if child is Island:
			child.island_hovered.connect(on_island_hovered)
			child.island_no_longer_hovered.connect(on_island_no_longer_hovered)

func _unhandled_input(event: InputEvent) -> void:
	'''
	For mouse movement:
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
			if event.button_index == MOUSE_BUTTON_LEFT and _hovered_bridge != null:
				_hovered_bridge.burn_bridge()
				_hovered_bridge = null
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom_out()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom_in()

func on_bridge_hovered(bridge: Bridge) -> void:
	_hovered_bridge = bridge
		
func on_bridge_unhovered() -> void:
	_hovered_bridge = null

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
		_drawn_bridge.queue_free()
		pass # TODO: show a "same island" popup
	elif(end_island.is_other_island_already_connected(_drawn_bridge.island_1)):
		print("Island already connected!")
		_drawn_bridge.queue_free()
		pass # TODO: show an "island already connected" popup
	else:
		_drawn_bridge.island_2 = end_island
		_drawn_bridge.set_ends_to_islands()
		_drawn_bridge.island_1.add_bridge(_drawn_bridge)
		_drawn_bridge.island_2.add_bridge(_drawn_bridge)
		_drawn_bridge.resize_collider()
		_drawn_bridge.bridge_hovered.connect(on_bridge_hovered)
		_drawn_bridge.bridge_unhovered.connect(on_bridge_unhovered)
	_drawn_bridge = null

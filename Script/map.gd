class_name Map extends Node2D


const _BRIDGE = preload("uid://bbfrx0mxarvxs")


@export var connection_array: Array[Connection] = []
@export var camera : Camera2D = null
@export var _test_island_1: Island = null
@export var _test_island_2: Island = null
@export var _test_island_3: Island = null


var _hovered_island : Island = null

func _ready() -> void:
	connect_island_signals()
	spawn_test_bridges()

func connect_island_signals():
	for child : Node in get_children():
		if child is Island:
			child.island_hovered.connect(on_island_hovered)
			child.island_no_longer_hovered.connect(on_island_no_longer_hovered)

func spawn_test_bridges():
	var test_bridge = (_BRIDGE.instantiate() as Bridge).build(_test_island_1, _test_island_2)
	add_child(test_bridge)
	var test_bridge_2 = (_BRIDGE.instantiate() as Bridge).build(_test_island_2, _test_island_3)
	add_child(test_bridge_2)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if event.button_mask == MOUSE_BUTTON_MASK_LEFT:
			camera.position -= event.relative / camera.zoom

	elif event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				camera.zoom_out()
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				camera.zoom_in()

func on_island_hovered(island : Island):
	print("Island " + island.ID + " hovered")
	self._hovered_island = island

func on_island_no_longer_hovered(island : Island):
	print("Island " + island.ID + " no longer hovered")
	self._hovered_island = null

class_name Map extends Node2D


const _BRIDGE = preload("res://scenes/bridge/bridge.tscn")


@export var connection_array: Array[Connection] = [] 
@export var _test_island_1: Island = null
@export var _test_island_2: Island = null


func _ready() -> void:
	var test_bridge = (_BRIDGE.instantiate() as Bridge).build(_test_island_1, _test_island_2)
	add_child(test_bridge)

class_name Island extends Area2D

@export var island_ID: int = -1


# Wraps existing signals mouse_entered and mouse_exited inside custom signals that also pass the island ID.
signal island_hovered(island)
signal island_no_longer_hovered(island)

func _ready() -> void:
    self.mouse_entered.connect(on_mouse_entered)
    self.mouse_exited.connect(on_mouse_exited)

func on_mouse_entered():
    island_hovered.emit(self)

func on_mouse_exited():
    island_no_longer_hovered.emit(self)
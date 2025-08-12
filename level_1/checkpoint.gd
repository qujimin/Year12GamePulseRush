extends Node2D
class_name Checkpoint

@export var spawnpoint: bool = false

var activated: bool = false

func _ready():
	if spawnpoint:
		activate()

func activate():
	activated = true
	PlayerManager.current_checkpoint = self
	print("Checkpoint activated at: ", global_position)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlatformerController2D and not activated:
		activate()

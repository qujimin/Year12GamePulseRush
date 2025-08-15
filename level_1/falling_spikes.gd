extends Node2D
@export var speed = 160.0
@export var reset_delay = 3.0
var current_speed = 0.0
@onready var spawn_pos = global_position
var has_dropped = false

func _physics_process(delta):
	position.y += current_speed * delta

func _on_hitbox_area_entered(area):
	if area.get_parent() is PlatformerController2D:
		area.get_parent().take_damage(1)
		reset_spike()

func fall():
	current_speed = speed
	await get_tree().create_timer(reset_delay).timeout
	reset_spike()

func reset_spike():
	position = spawn_pos
	current_speed = 0.0
	has_dropped = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlatformerController2D and not has_dropped:
		has_dropped = true
		create_tween().tween_property(self, "position", position + Vector2(0, 200), 1.0).set_ease(Tween.EASE_IN)
		fall()

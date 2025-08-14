extends Node2D

@export var speed = 160.0
var current_speed = 0.0

func _physics_process(delta):
	position.y += current_speed * delta

func _on_hitbox_area_entered(area):
	if area.get_parent() is PlatformerController2D:
		area.get_parent().die()
		queue_free()

func fall():
	current_speed = speed
	await get_tree().create_timer(5).timeout
	queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlatformerController2D:
		create_tween().tween_property(self, "position", position + Vector2(0, 200), 1.0).set_ease(Tween.EASE_IN)

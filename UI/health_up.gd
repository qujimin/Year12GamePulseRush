extends Node2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlatformerController2D:
		var player = area.get_parent()
		player.max_health += 1
		player.health += 1
		PlayerManager.update_health_display()  # Add this line
		queue_free()

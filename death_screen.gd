extends Control

func _on_main_menu_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://menu_scene/main_menu.tscn")

func _on_reset_pressed() -> void:
		get_tree().change_scene_to_file("res://level_1/level_1.tscn")

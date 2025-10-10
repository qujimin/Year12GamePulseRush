extends Control

var button_type = null

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1/level_1.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_scene/Options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

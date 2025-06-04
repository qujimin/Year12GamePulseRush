extends Control

var button_type = null

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://level_1.tscn")

func _on_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

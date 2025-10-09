extends Control
@onready var time_label = $TimeLabel
@onready var points_label = $PointsLabel
func _ready():
	print("WinScreen _ready() called")
	print("Children of WinScreen:")
	for child in get_children():
		print("  - ", child.name, " (", child.get_class(), ")")

	# Debug: Check if labels exist
	if time_label == null:
		push_error("TimeLabel not found! Available children printed above.")
	else:
		print("TimeLabel found successfully!")

	if points_label == null:
		push_error("PointsLabel not found! Available children printed above.")
	else:
		print("PointsLabel found successfully!")

	hide()
func show_win_screen(final_time: float, points: int):
	print("show_win_screen called with time:", final_time, " points:", points)
	show()
	get_tree().paused = true

	# Format time to match your timer format (MM:SS)
	var minutes = int(final_time) / 60
	var seconds = int(final_time) % 60

	# Safely set text only if labels exist
	if time_label != null:
		time_label.text = "Final Time: %02d:%02d" % [minutes, seconds]
		print("Time label set successfully")
	else:
		print("ERROR: time_label is null!")

	if points_label != null:
		points_label.text = "Points Collected: %d" % points
		print("Points label set successfully")
	else:
		print("ERROR: points_label is null!")
func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu_scene/main_menu.tscn")

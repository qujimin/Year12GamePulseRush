extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		# Get references to timer and game manager
		var timer = get_tree().get_first_node_in_group("timer")
		var game_manager = get_node("%GameManager")
		
		# Check if timer was found
		if timer == null:
			push_error("Timer not found! Make sure your timer Control node is in the 'timer' group.")
			return
		
		# Stop the timer
		timer.stop_timer()
		
		# Calculate final time (countdown_time - time_remaining)
		var time_elapsed = timer.countdown_time - timer.get_time_remaining()
		var final_points = game_manager.points
		
		print("Final time elapsed: ", time_elapsed)
		print("Final points: ", final_points)
		
		# Try multiple ways to find the win screen
		var win_screen = get_node_or_null("%WinScreen")
		if win_screen == null:
			win_screen = get_tree().current_scene.get_node_or_null("WinScreen")
		if win_screen == null:
			win_screen = get_tree().get_first_node_in_group("win_screen")
		
		if win_screen:
			win_screen.show_win_screen(time_elapsed, final_points)
		else:
			print("ERROR: Could not find WinScreen node!")
			print("Make sure WinScreen is added to the scene and set as unique name or in 'win_screen' group")

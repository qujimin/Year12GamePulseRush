extends Control

# Timer settings - adjust these values
@export var countdown_time: float = 60.0  # Time in seconds
@export var show_minutes: bool = true     # Show MM:SS format or just seconds

# Internal variables
var time_remaining: float
var is_running: bool = false
@onready var timer_label: Label = $TimerLabel  # Reference to Label node in the scene

func _ready():
	# Ensure the Label node exists
	if timer_label == null:
		push_error("TimerLabel node not found! Please add a Label node named 'TimerLabel' as a child of this Control.")
		return
	
	# Initialize the timer
	reset_timer()
	update_display()
	start_timer()  # Start the timer automatically for testing
	print("Timer initialized with ", countdown_time, " seconds")

func _process(delta):
	if is_running and time_remaining > 0:
		time_remaining -= delta
		update_display()
		print("Time remaining: ", time_remaining)  # Debug
		if time_remaining <= 0:
			time_remaining = 0
			is_running = false
			timer_finished()
	else:
		print("Process running, but timer not active. is_running: ", is_running, " time_remaining: ", time_remaining)

func update_display():
	var display_text: String
	if show_minutes:
		var minutes = int(time_remaining) / 60
		var seconds = int(time_remaining) % 60
		display_text = "%02d:%02d" % [minutes, seconds]
	else:
		display_text = "%.0f" % time_remaining
	timer_label.text = display_text

func start_timer():
	is_running = true
	print("Timer started!")

func stop_timer():
	is_running = false
	print("Timer stopped!")

func reset_timer():
	time_remaining = countdown_time
	is_running = false
	update_display()
	print("Timer reset to: ", countdown_time, " seconds")

func add_time(seconds: float):
	time_remaining += seconds
	if time_remaining < 0:
		time_remaining = 0
	update_display()

func timer_finished():
	print("Timer finished! Time remaining: ", time_remaining)
	# Switch to Death_Screen scene
	get_tree().change_scene_to_file("res://Death_Screen.tscn")

func get_time_remaining() -> float:
	return time_remaining

func is_timer_running() -> bool:
	return is_running

func set_countdown_time(new_time: float):
	countdown_time = new_time
	if not is_running:
		reset_timer()

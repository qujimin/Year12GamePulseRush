extends Control

# Timer settings - adjust these values
@export var countdown_time: float = 60.0  # Time in seconds
@export var show_minutes: bool = true     # Show MM:SS format or just seconds
@export var font_size: int = 48           # Text size
@export var timer_color: Color = Color.WHITE  # Text color

# Internal variables
var time_remaining: float
var is_running: bool = false
var timer_label: Label

func _ready():
	# Create the label for displaying the countdown
	timer_label = Label.new()
	add_child(timer_label)
	
	# Set up label properties
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	timer_label.anchors_preset = Control.PRESET_FULL_RECT
	
	# Apply formatting
	apply_formatting()
	
	# Initialize the timer
	reset_timer()
	update_display()

func apply_formatting():
	# Create theme override for font size and color
	timer_label.add_theme_font_size_override("font_size", font_size)
	timer_label.add_theme_color_override("font_color", timer_color)

func _process(delta):
	if is_running and time_remaining > 0:
		time_remaining -= delta
		update_display()
		
		# Check if timer finished
		if time_remaining <= 0:
			time_remaining = 0
			is_running = false
			timer_finished()

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
	print("Timer finished!")
	# Add your custom logic here for when timer reaches zero
	# Examples:
	# get_tree().change_scene_to_file("res://game_over.tscn")
	# player.take_damage(100)
	# spawn_enemy()

# Public functions you can call from other scripts:
func get_time_remaining() -> float:
	return time_remaining

func is_timer_running() -> bool:
	return is_running

func set_countdown_time(new_time: float):
	countdown_time = new_time
	if not is_running:
		reset_timer()

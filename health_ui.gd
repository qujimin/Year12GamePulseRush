extends Control

# Timer settings - adjust these values
@export var countdown_time: float = 60.0  # Time in seconds
@export var show_minutes: bool = true     # Show MM:SS format or just seconds
@export var font_size: int = 48           # Text size
@export var timer_color: Color = Color.WHITE  # Text color
@export var custom_font: FontFile         # Drag your font file here
@export var auto_start: bool = false      # Start timer automatically

# Position settings
@export_group("Position")
@export var timer_position: Vector2 = Vector2(100, 50)  # X, Y position

# Internal variables
var time_remaining: float
var is_running: bool = false
var timer_label: Label

func _ready():
	# Create the label for displaying the countdown
	timer_label = Label.new()
	add_child(timer_label)
	
	# Simple positioning - won't interfere with other UI
	timer_label.position = timer_position
	timer_label.size = Vector2(200, 60)
	
	# Apply formatting
	apply_formatting()
	
	# Initialize the timer
	reset_timer()
	update_display()
	
	# Auto-start if enabled
	if auto_start:
		call_deferred("start_timer")  # Start on next frame to ensure everything is ready

func apply_formatting():
	# Apply font size and color
	timer_label.add_theme_font_size_override("font_size", font_size)
	timer_label.add_theme_color_override("font_color", timer_color)
	
	# Apply custom font if provided
	if custom_font != null:
		timer_label.add_theme_font_override("font", custom_font)
	
	# Text alignment
	timer_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	timer_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

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
		display_text = "%.0f" % ceil(time_remaining)  # Use ceil to avoid showing 0 early
	
	timer_label.text = display_text
	
	# Debug print to check if it's updating
	print("Timer display: ", display_text, " | Time remaining: ", time_remaining)

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

func get_time_remaining() -> float:
	return time_remaining

func is_timer_running() -> bool:
	return is_running

func set_countdown_time(new_time: float):
	countdown_time = new_time
	if not is_running:
		reset_timer()

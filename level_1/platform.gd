extends CharacterBody2D

@export var radius: float = 50.0  # Smaller radius for tighter rotation
@export var rotation_speed: float = 1.0  # Speed multiplier (radians per second)
@export var clockwise: bool = true  # Rotation direction

var center_position: Vector2
var angle: float = 0.0

func _ready():
	# Store the initial position as the center of rotation
	center_position = global_position
	if center_position == null:
		push_error("Center position is null, check node setup")
		set_physics_process(false)
		return
	if radius <= 0.0 or radius == null:
		push_error("Radius is invalid or null: %s" % radius)
		radius = 50.0  # Fallback value
		set_physics_process(false)
		return
	if rotation_speed == null:
		push_error("Rotation speed is null: %s" % rotation_speed)
		rotation_speed = 1.0  # Fallback value
		set_physics_process(false)
		return
	print("Platform initialized - Center: ", center_position, ", Radius: ", radius, ", Speed: ", rotation_speed)

func _physics_process(delta):
	# Validate inputs
	if radius == null or rotation_speed == null:
		push_error("Invalid inputs - radius: %s, rotation_speed: %s" % [radius, rotation_speed])
		return
	
	# Update angle
	if clockwise:
		var angle_increment = rotation_speed * delta
		if angle_increment == null:
			push_error("Angle increment is null, rotation_speed: %s, delta: %s" % [rotation_speed, delta])
			return
		angle += angle_increment
	else:
		var angle_increment = rotation_speed * delta
		if angle_increment == null:
			push_error("Angle increment is null, rotation_speed: %s, delta: %s" % [rotation_speed, delta])
			return
		angle -= angle_increment
	
	# Normalize angle
	angle = fmod(angle, 2 * PI)
	
	# Calculate target position
	var x_component = cos(angle) * radius
	var y_component = sin(angle) * radius
	if x_component == null or y_component == null:
		push_error("Position components invalid - x: %s, y: %s, angle: %s, radius: %s" % [x_component, y_component, angle, radius])
		return
	var target_position = center_position + Vector2(x_component, y_component)
	
	# Set position
	global_position = target_position
	
	# Handle collisions
	velocity = Vector2.ZERO
	move_and_slide()
	
	# Debug
	print("Platform position: ", global_position, ", Angle: ", angle)

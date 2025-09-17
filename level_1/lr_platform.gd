extends CharacterBody2D

@export var distance: float = 200.0  # Total distance to travel left and right
@export var speed: float = 50.0  # Movement speed (pixels per second)
@export var start_moving_right: bool = true  # Initial direction

var start_position: Vector2
var target_position: Vector2
var moving_right: bool = true

func _ready():
	# Store the initial position as the starting point
	start_position = global_position
	if start_position == null:
		push_error("Start position is null, check node setup")
		set_physics_process(false)
		return
	
	if distance <= 0.0 or distance == null:
		push_error("Distance is invalid or null: %s" % distance)
		distance = 200.0  # Fallback value
		set_physics_process(false)
		return
	
	if speed <= 0.0 or speed == null:
		push_error("Speed is invalid or null: %s" % speed)
		speed = 50.0  # Fallback value
		set_physics_process(false)
		return
	
	# Set initial direction
	moving_right = start_moving_right
	
	# Calculate initial target position
	if moving_right:
		target_position = start_position + Vector2(distance / 2.0, 0)
	else:
		target_position = start_position - Vector2(distance / 2.0, 0)
	
	print("Platform initialized - Start: ", start_position, ", Distance: ", distance, ", Speed: ", speed)

func _physics_process(delta):
	# Validate inputs
	if speed == null or distance == null:
		push_error("Invalid inputs - speed: %s, distance: %s" % [speed, distance])
		return
	
	# Calculate movement direction
	var direction = (target_position - global_position).normalized()
	if direction == null:
		push_error("Direction calculation failed")
		return
	
	# Move the platform directly (ignore wall collisions)
	global_position += direction * speed * delta
	
	# Set velocity for any objects riding on the platform
	velocity = direction * speed
	
	# Check if we've reached the target position (with small tolerance)
	var distance_to_target = global_position.distance_to(target_position)
	if distance_to_target < speed * delta * 2.0:  # Small tolerance based on movement per frame
		# Snap to target position
		global_position = target_position
		
		# Flip direction and set new target
		moving_right = !moving_right
		if moving_right:
			target_position = start_position + Vector2(distance / 2.0, 0)
		else:
			target_position = start_position - Vector2(distance / 2.0, 0)
		
		# Stop velocity momentarily
		velocity = Vector2.ZERO
	
	# Debug
	print("Platform position: ", global_position, ", Moving right: ", moving_right, ", Target: ", target_position)

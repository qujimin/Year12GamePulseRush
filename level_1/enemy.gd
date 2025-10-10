extends CharacterBody2D

# Enemy states
enum State {
	IDLE,
	PATROL,
	DEAD
}

# Export variables for easy tweaking in editor
@export var patrol_speed: float = 50.0
@export var idle_time: float = 2.0
@export var patrol_distance: float = 100.0
@export var gravity: float = 980.0

# Node references
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var edge_detector: RayCast2D = $EdgeDetector
@onready var wall_detector: RayCast2D = $WallDetector
@onready var idle_timer: Timer = $IdleTimer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var area_2d: Area2D = $Area2D

# State variables
var current_state: State = State.IDLE
var direction: int = 1  # 1 for right, -1 for left
var start_position: Vector2
var is_dead: bool = false

func _ready():
	start_position = global_position
	
	# Setup timers
	idle_timer.wait_time = idle_time
	idle_timer.one_shot = true
	idle_timer.timeout.connect(_on_idle_timer_timeout)
	
	# Setup edge detector
	edge_detector.position = Vector2(0, 0)
	edge_detector.target_position = Vector2(20, 30)
	edge_detector.enabled = true
	
	# Setup wall detector
	wall_detector.position = Vector2(0, -10)
	wall_detector.target_position = Vector2(20, 0)
	wall_detector.enabled = true
	
	# Ensure Area2D is monitoring
	area_2d.monitoring = true
	area_2d.monitorable = true
	
	# Debug print to confirm Area2D setup
	print("Enemy Area2D monitoring: ", area_2d.monitoring, ", monitorable: ", area_2d.monitorable)
	
	# Start with idle state
	change_state(State.IDLE)

func _physics_process(delta):
	if is_dead:
		return
		
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	match current_state:
		State.IDLE:
			handle_idle_state()
		State.PATROL:
			handle_patrol_state()
	
	# Update ray cast positions based on direction
	update_detectors()
	
	# Move the character
	move_and_slide()

func handle_idle_state():
	velocity.x = 0
	
	# Play idle animation
	if animated_sprite.animation != "idle":
		animated_sprite.play("idle")

func handle_patrol_state():
	# Set velocity based on direction
	velocity.x = direction * patrol_speed
	
	# Play run animation
	if animated_sprite.animation != "run":
		animated_sprite.play("run")
	
	# Check for edge or wall collision
	if should_turn_around():
		turn_around()
		change_state(State.IDLE)

func should_turn_around():
	# Check if we've reached patrol distance
	var distance_from_start = abs(global_position.x - start_position.x)
	if distance_from_start >= patrol_distance:
		return true
	
	# Check if we're at an edge (no ground ahead)
	if not edge_detector.is_colliding():
		return true
	
	# Check if we hit a wall
	if wall_detector.is_colliding():
		return true
	
	return false

func turn_around():
	direction *= -1
	animated_sprite.flip_h = direction < 0

func update_detectors():
	# Update edge detector position
	edge_detector.position.x = 15 * direction
	edge_detector.target_position = Vector2(10 * direction, 30)
	
	# Update wall detector position
	wall_detector.position.x = 10 * direction
	wall_detector.target_position = Vector2(15 * direction, 0)

func change_state(new_state: State):
	current_state = new_state
	
	match new_state:
		State.IDLE:
			idle_timer.start()
		State.PATROL:
			idle_timer.stop()
		State.DEAD:
			die()

func _on_idle_timer_timeout():
	if current_state == State.IDLE:
		change_state(State.PATROL)

func die():
	print("Enemy dying!")
	current_state = State.DEAD
	velocity.x = 0
	# Play death animation
	if animated_sprite.sprite_frames and animated_sprite.sprite_frames.has_animation("death"):
		print("Playing death animation")
		animated_sprite.play("death")
	else:
		print("No death animation found, playing idle with red tint")
		animated_sprite.play("idle")
		animated_sprite.modulate = Color.RED
	# Add death effects like bouncing
	velocity.y = -200
	# Remove enemy after a delay
	await get_tree().create_timer(2.0).timeout
	queue_free()
	
func take_damage():
	if not is_dead:
		# Disable collisions immediately when taking damage
		is_dead = true
		collision_shape.disabled = true
		area_2d.monitoring = false
		area_2d.monitorable = false
		die()

func _on_area_2d_area_entered(area: Area2D):
	print("Area entered: ", area.name)
	
	if area.get_parent() is PlatformerController2D:
		var player = area.get_parent()
		print("Player detected! Player Y: ", player.global_position.y, " Enemy Y: ", global_position.y)
		
		# Calculate enemy top using collision shape
		var enemy_top = global_position.y - (collision_shape.shape.get_rect().size.y / 2) - 10
		print("Enemy top: ", enemy_top)
		
		if player.global_position.y < enemy_top:
			print("Player jumped on enemy head!")
			take_damage()
			if player.has_method("bounce"):
				player.bounce()
		else:
			print("Player hit enemy from side!")
			if player.has_method("take_damage"):
				player.take_damage(1)
			else:
				print("Player doesn't have take_damage method")

func _on_area_2d_area_exited(_area: Area2D) -> void:
	pass

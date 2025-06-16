extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -400.0
@onready var sprite_2d = $Sprite2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	# Animations:
	if (velocity.x > 1 or velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
		
	
	# Apply gravity when not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta  # Apply gravity to pull the character down
		sprite_2d.animation = "jumping"

	# Handle jump input
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY  # Set upward velocity only when jumping

	# Handle horizontal movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()

	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft

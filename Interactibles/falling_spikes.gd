extends Node2D
@export var speed = 160.0
var current_speed = 0.0
@onready var spawn_pos = global_position
var has_dropped = false
@onready var hitbox_bottom: float

func _ready():
	# Calculate the bottom of the PlayerDetect collision shape
	var player_detect_area = $PlayerDetect
	var collision_shape = player_detect_area.get_child(0)  # Get the CollisionShape2D
	if collision_shape is CollisionShape2D:
		var shape = collision_shape.shape
		var shape_bottom = collision_shape.position.y + (shape.get_rect().size.y / 2)
		hitbox_bottom = spawn_pos.y + shape_bottom

func _physics_process(delta):
	position.y += current_speed * delta
	
	# Stop when the spike's position reaches the bottom of its PlayerDetect area
	if has_dropped and position.y >= hitbox_bottom:
		current_speed = 0.0
		position.y = hitbox_bottom  # Snap to exact position

func _on_hitbox_area_entered(area):
	if area.get_parent() is PlatformerController2D:
		area.get_parent().take_damage(1)
		# Reset after dealing damage
		reset_spike()

func _on_player_detect_area_entered(area: Area2D) -> void:
	if area.get_parent() is PlatformerController2D and not has_dropped:
		has_dropped = true
		$AnimationPlayer.play("Shake")
		fall()

func fall():
	current_speed = speed
	await get_tree().create_timer(3.0).timeout
	# Only reset if we haven't hit the player (and already reset)
	if has_dropped:
		reset_spike()

func reset_spike():
	position = spawn_pos
	current_speed = 0.0
	has_dropped = false
	$AnimationPlayer.stop()  # Stop the shake animation

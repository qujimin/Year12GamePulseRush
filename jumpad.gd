extends Node2D

@export var launch_force: Vector2 = Vector2(0, -800)
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	# Start with idle animation
	animated_sprite.play("idle")
	
	# Connect the area detection
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if body is PlatformerController2D:
		launch_player(body)

func launch_player(player) -> void:
	# Launch the player
	player.velocity += launch_force
	
	# Play jump animation
	animated_sprite.play("jump")
	
	# Return to idle when jump animation finishes
	animated_sprite.animation_finished.connect(_on_animation_finished, CONNECT_ONE_SHOT)

func _on_animation_finished() -> void:
	animated_sprite.play("idle")

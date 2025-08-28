extends Area2D

@export var launch_force: Vector2 = Vector2(0, -800)
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var has_triggered: bool = false

func _ready() -> void:
	animated_sprite_2d.play("idle")
	# Explicitly disable looping for jump animation
	if animated_sprite_2d.sprite_frames:
		animated_sprite_2d.sprite_frames.set_animation_loop("jump", false)
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	animated_sprite_2d.animation_finished.connect(_on_animated_sprite_2d_animation_finished)

func _on_body_entered(body: Node2D) -> void:
	if has_triggered:
		return
	if body is PlatformerController2D and body.global_position.y < global_position.y:
		has_triggered = true
		print("Trigger: Player entered from above, launching, playing jump")
		# Launch player
		body.velocity += launch_force
		# Play jump animation
		animated_sprite_2d.play("jump")

func _on_body_exited(body: Node2D) -> void:
	if body is PlatformerController2D:
		has_triggered = false
		print("Player exited, has_triggered reset to false")

func _on_animated_sprite_2d_animation_finished() -> void:
	print("Animation finished: ", animated_sprite_2d.animation)
	if animated_sprite_2d.animation == "jump":
		animated_sprite_2d.play("idle")

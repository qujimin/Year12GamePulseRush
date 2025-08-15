extends Node2D

@export var launch_force: Vector2 = Vector2(0, -800)
@onready var animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	animated_sprite.play("idle")
	$Area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(body) -> void:
	if body is PlatformerController2D:
		# Launch player
		body.velocity += launch_force
		
		# Play jump animation and leave it there
		animated_sprite.play("jump")

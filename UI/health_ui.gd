# HealthUI.gd
extends Control

@onready var health_container = $HealthContainer
@export var heart_texture: Texture2D  # Drag your heart sprite here in inspector
@export var empty_heart_texture: Texture2D  # Optional: empty heart sprite

var current_hearts = []

func _ready():
	# Connect to player health changes
	if PlayerManager.player:
		update_health_display(PlayerManager.player.health, PlayerManager.player.max_health)
	
	# Update when player changes
	PlayerManager.connect("player_health_changed", _on_player_health_changed)

func _on_player_health_changed(current_health: int, max_health: int):
	update_health_display(current_health, max_health)

func update_health_display(current_health: int, max_health: int):
	# Clear existing hearts
	for heart in current_hearts:
		heart.queue_free()
	current_hearts.clear()
	
	# Create hearts based on max_health
	for i in range(max_health):
		var heart_sprite = TextureRect.new()
		heart_sprite.texture = heart_texture
		heart_sprite.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		heart_sprite.custom_minimum_size = Vector2(32, 32)  # Adjust size as needed
		
		# Show filled heart if within current health, empty if not
		if i < current_health:
			heart_sprite.modulate = Color.WHITE
		else:
			if empty_heart_texture:
				heart_sprite.texture = empty_heart_texture
			else:
				heart_sprite.modulate = Color(1, 1, 1, 0.3)  # Make it semi-transparent
		
		health_container.add_child(heart_sprite)
		current_hearts.append(heart_sprite)

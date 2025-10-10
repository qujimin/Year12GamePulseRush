extends Node

signal player_health_changed(current_health: int, max_health: int)

const CheckpointScript = preload("res://level_1/checkpoint.gd")
const Player = preload("res://Ultimate 2D Platformer Controller v1.1.0/Ultimate 2D Platformer Controller v1.0.3/UltimatePlatformerController.gd")

var current_checkpoint: Checkpoint
var player: Player

func respawn_player():
	# Health is reset to base amount (temporary bonus was already cleared in die())
	player.health = player.max_health  # This will be base_max_health since temporary_health_bonus = 0
	
	if player == null:
		print("Error: Player is null in PlayerManager!")
		return
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		print("Player respawned at: ", current_checkpoint.global_position)
		# Emit health change signal
		player_health_changed.emit(player.health, player.max_health)
	else:
		print("No checkpoint set! Cannot respawn player.")

func update_health_display():
	if player:
		player_health_changed.emit(player.health, player.max_health)

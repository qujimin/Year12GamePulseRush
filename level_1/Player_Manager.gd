extends Node

const CheckpointScript = preload("res://level_1/checkpoint.gd")
const Player = preload("res://Ultimate 2D Platformer Controller v1.1.0/Ultimate 2D Platformer Controller v1.0.3/UltimatePlatformerController.gd")
var current_checkpoint: Checkpoint
var player: Player

func respawn_player():
	if player == null:
		print("Error: Player is null in PlayerManager!")
		return
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
		print("Player respawned at: ", current_checkpoint.global_position)
	else:
		print("No checkpoint set! Cannot respawn player.")

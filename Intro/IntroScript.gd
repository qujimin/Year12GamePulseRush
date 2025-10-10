extends Node2D

@onready var animation_intro = $AnimationPlayer


func _ready():
	animation_intro.play("Black_in")
	get_tree().create_timer(5).timeout.connect(black_out)
 

func black_out():
	animation_intro.play("Black_out")
	get_tree().create_timer(5).timeout.connect(start_menu_scene)
 

func start_menu_scene():
	get_tree().change_scene_to_file("res://menu_scene/main_menu.tscn")

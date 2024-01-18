extends Node3D


func _ready():
	EventBus.start_game.connect(_on_start_requested)


func _on_start_requested():
	get_tree().change_scene_to_file("res://scenes/environments/level/level.tscn")

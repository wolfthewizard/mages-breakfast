extends Node3D


@onready var game_over = $GameOver


func _ready():
	EventBus.player_cut.connect(_on_player_cut)


func _on_player_cut():
	get_tree().paused = true
	game_over.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

extends Node3D


@onready var game_over = $GameOver
@onready var pause = $Pause


func _ready():
	EventBus.player_cut.connect(_on_player_cut)


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pause.visible = true


func _on_player_cut():
	get_tree().paused = true
	game_over.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

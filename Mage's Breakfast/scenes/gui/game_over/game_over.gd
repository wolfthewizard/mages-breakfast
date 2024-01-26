extends Control

@onready var new_label = $CenterContainer/VBoxContainer/HBoxContainer/NewLabel
@onready var high_score_label = $CenterContainer/VBoxContainer/HBoxContainer/HighScoreLabel

const BUTTER_SIZE = 0.1
const KCAL_PER_M3 = 0.911 * 1000 * 7168		# kg/l * l/m3 * kcal/kg
const SCORE_PATH = "user://hiscore.hs"

var score: float = 0.0


func _ready():
	EventBus.player_cut.connect(get_high_score)
	EventBus.butter_height_changed.connect(store_score)


func get_high_score():
	var high_score = 0.0
	if FileAccess.file_exists(SCORE_PATH):
		var score_file = FileAccess.open(SCORE_PATH, FileAccess.READ)
		var line = score_file.get_line()
		score_file.close()
		var score_dict = JSON.parse_string(line)
		high_score = score_dict["score"]
	if score > high_score:
		high_score = score
		new_label.visible = true
		var score_file = FileAccess.open(SCORE_PATH, FileAccess.WRITE)
		var score_dict = {
			"score": score,
		}
		score_file.store_line(JSON.stringify(score_dict))
		score_file.close()
	high_score_label.text = "high score: %d" % high_score


func store_score(h: float):
	var volume = h * BUTTER_SIZE * BUTTER_SIZE
	var kcal = volume * KCAL_PER_M3
	score = kcal


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/level/level.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_return_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/menu/menu.tscn")

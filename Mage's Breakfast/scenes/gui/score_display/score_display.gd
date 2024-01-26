class_name ScoreDisplay extends Control


@onready var label = $Label
const BUTTER_SIZE = 0.1
const KCAL_PER_M3 = 0.911 * 1000 * 7168		# kg/l * l/m3 * kcal/kg


func _ready():
	EventBus.butter_height_changed.connect(score_from_butter_height)


func score_from_butter_height(h: float):
	var volume = h * BUTTER_SIZE * BUTTER_SIZE
	var kcal = volume * KCAL_PER_M3
	var kcal_parsed = "%d" % kcal
	label.text = "kcal: %s" % kcal_parsed

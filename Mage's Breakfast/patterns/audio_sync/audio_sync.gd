extends Node

@onready var music_id = AudioServer.get_bus_index("Music")
@onready var sfx_id = AudioServer.get_bus_index("SFX")

const SETTINGS_PATH = "user://settings.st"


func _ready():
	if not FileAccess.file_exists(SETTINGS_PATH):
		return
	var audio_file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
	var line = audio_file.get_line()
	audio_file.close()
	var settings = JSON.parse_string(line)
	var music_volume = settings["music_volume"]
	var sfx_volume = settings["sfx_volume"]
	AudioServer.set_bus_volume_db(
		music_id, 
		music_volume
	)
	AudioServer.set_bus_volume_db(
		sfx_id, 
		sfx_volume
	)


func save_settings(music_volume: float, sfx_volume: float):
	var audio_file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	var settings = {
		"music_volume": music_volume,
		"sfx_volume": sfx_volume
	}
	audio_file.store_line(JSON.stringify(settings))
	audio_file.close()

extends Control

@onready var original_music_volume = AudioServer.get_bus_volume_db(AudioSync.music_id)
@onready var original_sfx_volume = AudioServer.get_bus_volume_db(AudioSync.sfx_id)
@onready var music_volume_slider = $CenterContainer/VBoxContainer/GridContainer/MusicVolumeSlider
@onready var sfx_volume_slider = $CenterContainer/VBoxContainer/GridContainer/SFXVolumeSlider


func _ready():
	EventBus.open_settings.connect(_on_open_settings)


func _on_open_settings():
	visible = true


func _on_cancel_button_pressed():
	AudioServer.set_bus_volume_db(AudioSync.music_id, original_music_volume)
	AudioServer.set_bus_volume_db(AudioSync.sfx_id, original_sfx_volume)
	music_volume_slider.value = db_to_linear(original_music_volume)
	sfx_volume_slider.value = db_to_linear(original_sfx_volume)
	visible = false
	EventBus.close_settings.emit()


func _on_confirm_button_pressed():
	original_music_volume = AudioServer.get_bus_volume_db(AudioSync.music_id)
	original_sfx_volume = AudioServer.get_bus_volume_db(AudioSync.sfx_id)
	AudioSync.save_settings(original_music_volume, original_sfx_volume)
	visible = false
	EventBus.close_settings.emit()

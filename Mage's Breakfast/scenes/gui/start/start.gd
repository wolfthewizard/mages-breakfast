extends Control


func _ready():
	EventBus.close_settings.connect(_on_settings_closed)


func _on_settings_closed():
	visible = true


func _on_start_button_pressed():
	EventBus.start_game.emit()


func _on_settings_button_pressed():
	visible = false
	EventBus.open_settings.emit()


func _on_exit_button_pressed():
	get_tree().quit()

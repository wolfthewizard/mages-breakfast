extends Control


func _on_start_button_pressed():
	EventBus.start_game.emit()


func _on_settings_button_pressed():
	EventBus.open_settings.emit()

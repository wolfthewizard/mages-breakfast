extends Control


func _on_start_button_pressed():
	EventBus.start_game.emit()


func _on_settings_button_pressed():
	EventBus.open_settings.emit()


func _on_exit_button_pressed():
	get_tree().quit()

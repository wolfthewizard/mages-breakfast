extends Control


func _ready():
	EventBus.close_settings.connect(_on_settings_closed)


func _on_settings_closed():
	visible = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		_on_resume_button_pressed()
		accept_event()


func _on_resume_button_pressed():
	get_tree().paused = false
	visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_settings_button_pressed():
	visible = false
	EventBus.open_settings.emit()


func _on_return_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/menu/menu.tscn")

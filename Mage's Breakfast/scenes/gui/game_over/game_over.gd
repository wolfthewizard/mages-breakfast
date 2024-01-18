extends Control


func _on_restart_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/level/level.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_return_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/menu/menu.tscn")

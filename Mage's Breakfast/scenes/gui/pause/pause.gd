extends Control


func _on_resume_button_pressed():
	get_tree().paused = false
	visible = false


func _on_settings_button_pressed():
	pass # Replace with function body.


func _on_return_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/environments/menu/menu.tscn")

extends Node3D


@onready var spring_arm = $SubViewportContainer/SubViewport/CameraPivot/SpringArm3D

const CAMERA_ROTATION_PAN_TIME = 10
const MAX_CAMERA_ROTATION = TAU / 20


func _ready():
	EventBus.start_game.connect(_on_start_requested)
	spring_arm.rotation.y = MAX_CAMERA_ROTATION
	var vec1 = Vector3(spring_arm.rotation.x, -MAX_CAMERA_ROTATION, spring_arm.rotation.z)
	var vec2 = Vector3(spring_arm.rotation.x, MAX_CAMERA_ROTATION, spring_arm.rotation.z)
	var tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE)
	tween.tween_property(spring_arm, "rotation", vec1, CAMERA_ROTATION_PAN_TIME)
	tween.tween_property(spring_arm, "rotation", vec2, CAMERA_ROTATION_PAN_TIME)


func _on_start_requested():
	get_tree().change_scene_to_file("res://scenes/environments/level/level.tscn")

extends CharacterBody3D


@onready var camera_pivot = $CameraPivot
@onready var spring_arm = $CameraPivot/SpringArm3D
@onready var player_mesh := $PlayerMesh
@onready var collision_shape = $CollisionShape3D

const TURN_SMOOTHING = 0.15
const SPEED = 0.025
const JUMP_VELOCITY = 0.025
const ZOOM_STEP = 0.005
const ZOOM_MIN = 0.05
const ZOOM_MAX = 0.2

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().quit()
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			camera_pivot.rotate_y(-event.relative.x * 0.01)
			spring_arm.rotate_x(-event.relative.y * 0.01)
			spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI / 2, PI / 2)
		elif event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				spring_arm.spring_length = min(spring_arm.spring_length + ZOOM_STEP, ZOOM_MAX)
			elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
				spring_arm.spring_length = max(spring_arm.spring_length - ZOOM_STEP, ZOOM_MIN)
				

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = Vector3(input_dir.x, 0, input_dir.y).normalized()
	direction = direction.rotated(Vector3.UP, camera_pivot.rotation.y)
	if direction:
		player_mesh.rotation.y = lerp_angle(
			player_mesh.rotation.y, 
			atan2(-velocity.x, -velocity.z), 
			TURN_SMOOTHING
		)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

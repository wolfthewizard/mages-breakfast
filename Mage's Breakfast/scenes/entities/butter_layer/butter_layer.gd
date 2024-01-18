class_name ButterLayer extends AnimatableBody3D


@onready var top_center_point = $TopCenterPoint
@onready var attack_overlay = $AttackOverlay

const OVERLAY_FADE_IN_PART = 0.2
const OVERLAY_PRESENT_PART = 0.6
const OVERLAY_FADE_OUT_PART = 0.2
const OVERLAY_MIN_TRANSPARENCY = 0.05

var tween: Tween


func _ready():
	EventBus.attack_in_preparation.connect(_on_attack_in_preparation_emmited)


func _on_attack_in_preparation_emmited(angle: float, prep_time: float):
	print(prep_time)
	attack_overlay.mesh.material.set_shader_parameter("angle", angle)
	tween = create_tween()
	tween.tween_property(attack_overlay, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(attack_overlay, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)

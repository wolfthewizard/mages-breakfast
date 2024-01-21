class_name ButterLayer extends AnimatableBody3D


@onready var top_center_point = $TopCenterPoint
@onready var telegraph_attack_mow = $Telegraphs/TelegraphAttackMow
@onready var telegraph_attack_stab = $Telegraphs/TelegraphAttackStab
@onready var telegraph_attack_whirlwind = $Telegraphs/TelegraphAttackWhirlwind

const OVERLAY_FADE_IN_PART = 0.2
const OVERLAY_PRESENT_PART = 0.6
const OVERLAY_FADE_OUT_PART = 0.2
const OVERLAY_MIN_TRANSPARENCY = 0.05

var tween: Tween


func _ready():
	EventBus.mow_attack_preparing.connect(_on_mow_attack_preparing)
	EventBus.stab_attack_preparing.connect(_on_stab_attack_preparing)
	EventBus.whirlwind_attack_preparing.connect(_on_whirlwind_attack_preparing)


func _on_mow_attack_preparing(angle: float, prep_time: float):
	telegraph_attack_mow.mesh.material.set_shader_parameter("angle", angle)
	tween = create_tween()
	tween.tween_property(telegraph_attack_mow, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_mow, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)


func _on_stab_attack_preparing(from: Vector2, to: Vector2, prep_time: float):
	telegraph_attack_stab.mesh.material.set_shader_parameter("from", from)
	telegraph_attack_stab.mesh.material.set_shader_parameter("to", to)
	tween = create_tween()
	tween.tween_property(telegraph_attack_stab, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_stab, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)


func _on_whirlwind_attack_preparing(angle: float, reversed: bool, prep_time: float):
	telegraph_attack_whirlwind.mesh.material.set_shader_parameter("angle", angle)
	telegraph_attack_whirlwind.mesh.material.set_shader_parameter("reverse", reversed)
	tween = create_tween()
	tween.tween_property(telegraph_attack_whirlwind, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_whirlwind, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)

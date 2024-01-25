class_name ButterLayer extends AnimatableBody3D


@onready var top_center_point = $TopCenterPoint
@onready var telegraph_attack_mow = $TopCenterPoint/Telegraphs/TelegraphAttackMow
@onready var telegraph_attack_stab = $TopCenterPoint/Telegraphs/TelegraphAttackStab
@onready var telegraph_attack_whirlwind = $TopCenterPoint/Telegraphs/TelegraphAttackWhirlwind
@onready var butter_mesh = $ButterMesh
@onready var butter_collision = $ButterCollision

const OVERLAY_FADE_IN_PART = 0.2
const OVERLAY_PRESENT_PART = 0.6
const OVERLAY_FADE_OUT_PART = 0.2
const OVERLAY_MIN_TRANSPARENCY = 0.05
const HEIGHT_PER_SECOND_MOW = 0.005
const HEIGHT_PER_SECOND_STAB = 0.002
const HEIGHT_PER_SECOND_WHIRLWIND = 0.001

var tween: Tween
var height: float = 0.002:
	set(value):
		height = value
		butter_mesh.mesh.size.y = height
		butter_mesh.position.y = height / 2
		butter_collision.shape.size.y = height
		butter_collision.position.y = height / 2
		top_center_point.position.y = height
var knife: Knife
var knife_in: bool = false
enum Type {
	MOW,
	STAB,
	WHIRLWIND
}
var attack_type: Type


func _ready():
	height = height		# XD if not done, mesh&collision does not reset
	EventBus.mow_attack_preparing.connect(_on_mow_attack_preparing)
	EventBus.stab_attack_preparing.connect(_on_stab_attack_preparing)
	EventBus.whirlwind_attack_preparing.connect(_on_whirlwind_attack_preparing)


func _process(delta):
	if knife_in and knife.is_spreading:
		var mult
		match attack_type:
			Type.MOW:
				mult = HEIGHT_PER_SECOND_MOW
			Type.STAB:
				mult = HEIGHT_PER_SECOND_STAB
			Type.WHIRLWIND:
				mult = HEIGHT_PER_SECOND_WHIRLWIND	
		height += mult * knife.spreading_factor * delta


func _on_mow_attack_preparing(angle: float, prep_time: float):
	attack_type = Type.MOW
	telegraph_attack_mow.mesh.material.set_shader_parameter("angle", angle)
	tween = create_tween()
	tween.tween_property(telegraph_attack_mow, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_mow, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)


func _on_stab_attack_preparing(from: Vector2, to: Vector2, prep_time: float):
	attack_type = Type.STAB
	telegraph_attack_stab.mesh.material.set_shader_parameter("from", from)
	telegraph_attack_stab.mesh.material.set_shader_parameter("to", to)
	tween = create_tween()
	tween.tween_property(telegraph_attack_stab, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_stab, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)


func _on_whirlwind_attack_preparing(angle: float, reversed: bool, prep_time: float):
	attack_type = Type.WHIRLWIND
	telegraph_attack_whirlwind.mesh.material.set_shader_parameter("angle", angle)
	telegraph_attack_whirlwind.mesh.material.set_shader_parameter("reverse", reversed)
	tween = create_tween()
	tween.tween_property(telegraph_attack_whirlwind, "transparency", OVERLAY_MIN_TRANSPARENCY, prep_time * OVERLAY_FADE_IN_PART)
	tween.tween_property(telegraph_attack_whirlwind, "transparency", 1.0, prep_time * OVERLAY_FADE_OUT_PART).set_delay(prep_time * OVERLAY_PRESENT_PART)


func _on_spread_area_area_entered(area):
	knife_in = true


func _on_spread_area_area_exited(area):
	knife_in = false

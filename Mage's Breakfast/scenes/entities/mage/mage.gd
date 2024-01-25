class_name Mage extends Node3D


@export var knife: Knife
@export var butter_layer: ButterLayer
@export var player: Player
@export var mow_attack_distance: float = 0.15
@export var stab_attack_distance: float = 0.3

@onready var attack_timer: Timer = $AttackTimer

const ELEVATION = 0.001
const TIME_SCALING_FACTOR = 0.95
const ATTACK_THRESHOLDS = [
	0.5,
	0.85,
	1
]

var time_scaling: float = 1.0


func prepare_mow():
	var source = Vector3(0, ELEVATION, mow_attack_distance).rotated(Vector3.UP, randf_range(0, TAU))
	var dest = Vector3(-source.x, source.y, -source.z)
	knife.mow_attack(source, dest)
	var angle = Vector3.FORWARD.signed_angle_to(source.direction_to(dest), Vector3.UP)
	EventBus.mow_attack_preparing.emit(angle, knife.attack_preparation + knife.attack_delay + knife.attack_duration)


func prepare_stab():
	var angle: float = randf_range(0, TAU)
	var source = Vector3(0, ELEVATION, stab_attack_distance).rotated(Vector3.UP, angle)
	var dest = Vector3(player.position.x, ELEVATION, player.position.z)
	dest += Vector3(randf_range(-0.01, 0.01), 0, randf_range(-0.01, 0.01))
	knife.stab_attack(source, dest)
	EventBus.stab_attack_preparing.emit(
		Vector2(source.x, -source.z) / 0.05, 
		Vector2(dest.x, -dest.z) / 0.05, 
		knife.attack_preparation + knife.attack_delay + knife.attack_duration
	)


func prepare_whirlwind():
	var flip_direction: bool = randf() < 0.5
	var source = Vector3(0, ELEVATION, mow_attack_distance).rotated(Vector3.UP, randf_range(0, TAU))
	var dest = Vector3(0, ELEVATION, 0)
	knife.whirlwind_attack(source, dest, flip_direction)
	EventBus.whirlwind_attack_preparing.emit(
		Vector3.FORWARD.signed_angle_to(dest - source, Vector3.UP),
		flip_direction,
		knife.attack_preparation + knife.attack_delay * 2 + knife.attack_duration
	)


func _on_attack_timer_timeout():
	var decider = randf()
	if decider < ATTACK_THRESHOLDS[0]:
		prepare_mow()
	elif decider < ATTACK_THRESHOLDS[1]:
		prepare_stab()
	else:
		prepare_whirlwind()


func _on_knife_attack_sequence_finished():
	attack_timer.start()
	time_scaling *= TIME_SCALING_FACTOR
	knife.time_scaling = time_scaling

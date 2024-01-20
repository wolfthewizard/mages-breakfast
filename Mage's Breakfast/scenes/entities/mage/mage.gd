class_name Mage extends Node3D


@export var knife: Knife
@export var butter_layer: ButterLayer
@export var mow_attack_distance: float = 0.15
@export var stab_attack_distance: float = 0.3

@onready var attack_timer: Timer = $AttackTimer

const TIME_SCALING_FACTOR = 0.95

var time_scaling: float = 1.0


func prepare_mow():
	var source = Vector3(0, 0.01, mow_attack_distance).rotated(Vector3.UP, randf_range(0, TAU))
	var dest = Vector3(-source.x, source.y, -source.z)
	knife.mow_attack(source, dest)
	var angle = Vector3.FORWARD.signed_angle_to(source.direction_to(dest), Vector3.UP)
	EventBus.attack_in_preparation.emit(angle, knife.attack_preparation + knife.attack_delay + knife.attack_duration)


func prepare_stab():
	var angle: float = randf_range(0, TAU)
	var source = Vector3(0, 0.01, stab_attack_distance).rotated(Vector3.UP, angle)
	angle += PI / 4
	angle = fmod(angle, TAU)
	var on_x: bool = fmod(angle, PI) < PI / 2
	var dest_point = randf_range(-0.025, 0.025)
	var dest = Vector3(dest_point, 0.01, 0) if on_x else Vector3(0, 0.01, dest_point)
	knife.stab_attack(source, dest)


func prepare_whirlwind():
	var flip_direction: bool = randf() < 0.5
	var source = Vector3(0, 0.01, mow_attack_distance).rotated(Vector3.UP, randf_range(0, TAU))
	var dest = Vector3(0, 0.01, 0)
	knife.whirlwind_attack(source, dest, flip_direction)


func _on_attack_timer_timeout():
	#prepare_mow()
	#prepare_stab()
	prepare_whirlwind()


func _on_knife_attack_sequence_finished():
	attack_timer.start()
	time_scaling *= TIME_SCALING_FACTOR
	knife.time_scaling = time_scaling

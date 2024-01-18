class_name Mage extends Node3D


@export var knife: Knife
@export var butter_layer: ButterLayer
@export var mow_attack_distance: float = 0.15

@onready var attack_timer: Timer = $AttackTimer

const TIME_SCALING_FACTOR = 0.95

var time_scaling: float = 1.0


func prepare_mow():
	var source = Vector3(0, 0.01, mow_attack_distance).rotated(Vector3.UP, randf_range(0, TAU))
	var dest = Vector3(-source.x, source.y, -source.z)
	knife.mow_attack(source, dest)
	var angle = Vector3.FORWARD.signed_angle_to(source.direction_to(dest), Vector3.UP)
	EventBus.attack_in_preparation.emit(angle, knife.attack_preparation + knife.attack_delay + knife.attack_duration)


func _on_attack_timer_timeout():
	prepare_mow()


func _on_knife_attack_sequence_finished():
	attack_timer.start()
	time_scaling *= TIME_SCALING_FACTOR
	knife.time_scaling = time_scaling

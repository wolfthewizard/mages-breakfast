class_name Knife extends Node3D


signal attack_sequence_finished


@export var player: CharacterBody3D
@export var attack_preparation: float = 1:
	get:
		return attack_preparation * time_scaling
@export var attack_delay: float = 0.2:
	get:
		return attack_delay * time_scaling
@export var attack_duration: float = 2:
	get:
		return attack_duration * time_scaling

var time_scaling: float = 1.0

var tween: Tween


func mow_attack(from: Vector3, to: Vector3):
	var original_position = global_position
	var original_basis = basis
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "global_position", from, attack_preparation)
	tween.parallel().tween_property(self, "basis", Basis.looking_at(to - from, Vector3.UP), attack_preparation).set_delay(attack_delay)
	tween.tween_property(self, "global_position", to, attack_duration)
	tween.tween_property(self, "global_position", original_position, attack_preparation)
	tween.parallel().tween_property(self, "basis", original_basis, attack_preparation)
	tween.tween_callback(func(): attack_sequence_finished.emit())


func _on_killbox_body_entered(body):
	if body == player:
		EventBus.player_cut.emit()

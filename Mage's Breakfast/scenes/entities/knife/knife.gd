class_name Knife extends Node3D


signal attack_sequence_finished


@export var player: CharacterBody3D
@export var attack_preparation: float = 2:
	get:
		return attack_preparation * time_scaling
@export var attack_delay: float = 0.2:
	get:
		return attack_delay * time_scaling
@export var attack_duration: float = 2:
	get:
		return attack_duration * time_scaling
@export var stab_attack_linger: float = 1		# intentional, should not scale with time
@export var whirlwind_attack_duration: float = 4:
	get:
		return whirlwind_attack_duration * time_scaling

var spreading_factor: float:
	get:
		return 1 / time_scaling
var time_scaling: float = 1.0
var tween: Tween
var is_spreading: bool = false


func mow_attack(from: Vector3, to: Vector3):
	var original_position = position
	var original_basis = basis
	var new_basis = Basis.looking_at(to - from, Vector3.UP
		).scaled(original_basis.get_scale())
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", from, attack_preparation)
	tween.parallel().tween_property(self, "basis", new_basis, attack_preparation)
	tween.tween_callback(func(): is_spreading = true)
	tween.tween_property(self, "position", to, attack_duration
		).set_delay(attack_delay)
	tween.tween_callback(func(): is_spreading = false)
	tween.tween_property(self, "position", original_position, attack_preparation)
	tween.parallel().tween_property(self, "basis", original_basis, attack_preparation)
	tween.tween_callback(func(): attack_sequence_finished.emit())


func stab_attack(from: Vector3, to: Vector3):
	var original_position = position
	var original_basis = basis
	var new_basis = Basis.looking_at(to - from, Vector3.UP
		).rotated(Vector3.UP, -PI / 2
		).scaled(original_basis.get_scale())
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", from, attack_preparation)
	tween.parallel().tween_property(self, "basis", new_basis, attack_preparation)
	tween.tween_callback(func(): is_spreading = true)
	tween.tween_property(self, "position", to, attack_duration
		).set_delay(attack_delay)
	tween.tween_callback(func(): is_spreading = false)
	tween.tween_callback(func(): is_spreading = true
		).set_delay(stab_attack_linger)
	tween.tween_property(self, "position", from, attack_preparation)
	tween.tween_callback(func(): is_spreading = false)
	tween.tween_property(self, "position", original_position, attack_preparation)
	tween.parallel().tween_property(self, "basis", original_basis, attack_preparation)
	tween.tween_callback(func(): attack_sequence_finished.emit())


func whirlwind_attack(from: Vector3, to: Vector3, flip_direction: bool):
	var original_position = position
	var original_basis = basis
	var new_basis = Basis.looking_at(to - from, Vector3.UP
		).rotated(Vector3.UP, -PI / 2
		).scaled(original_basis.get_scale())
	var angle_diff = rotation.y + TAU if not flip_direction else rotation.y - TAU
	var rotation_diff = Vector3(0, angle_diff, 0)
	var target_rotation = new_basis.get_euler() + rotation_diff
	tween = create_tween().set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(self, "position", from, attack_preparation)
	tween.parallel().tween_property(self, "basis", new_basis, attack_preparation)
	tween.tween_callback(func(): is_spreading = true)
	tween.tween_property(self, "position", to, attack_duration
		).set_delay(attack_delay)
	tween.tween_callback(func(): is_spreading = false)
	tween.tween_callback(func(): is_spreading = true
		).set_delay(attack_delay)
	tween.tween_property(self, "rotation", target_rotation, whirlwind_attack_duration
		).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(func(): rotation.y -= TAU if not flip_direction else -TAU)
	tween.tween_callback(func(): is_spreading = false)
	tween.tween_property(self, "position", original_position, attack_preparation
		).set_delay(attack_delay)
	tween.parallel().tween_property(self, "basis", original_basis, attack_preparation)
	tween.tween_callback(func(): attack_sequence_finished.emit())


func _on_killbox_body_entered(body):
	if body == player:
		EventBus.player_cut.emit()

class_name Knife extends Node3D


@export var player: CharacterBody3D
@export var attack_preparation: float = 1
@export var attack_delay: float = 0.2
@export var attack_duration: float = 5

var tween: Tween



func _ready():
	mow_attack(Vector3(0, 0.1, 0.08), Vector3(0, 0.1, -0.08))


func _physics_process(_delta):
	pass


func mow_attack(from: Vector3, to: Vector3):
	var original_position = global_position
	tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	tween.tween_property(self, "global_position", from, attack_preparation)
	tween.tween_property(self, "basis", Basis.looking_at(to - from, Vector3.UP), attack_preparation).set_delay(attack_delay)
	tween.chain().tween_property(self, "global_position", to, attack_duration)
	tween.chain().tween_property(self, "global_position", original_position, attack_preparation)


func _on_killbox_body_entered(body):
	if body == player:
		player.queue_free()

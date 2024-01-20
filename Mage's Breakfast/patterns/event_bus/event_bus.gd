extends Node


# gui
signal start_game
signal open_settings

# gameplay
signal attack_in_preparation(angle: float, prep_time: float)
signal stab_attack_preparing(from: Vector2, to: Vector2, prep_time: float)
signal whirlwind_attack_preparing()
signal player_cut

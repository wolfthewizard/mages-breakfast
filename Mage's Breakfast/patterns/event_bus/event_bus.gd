extends Node


# gui
signal start_game
signal open_settings
signal close_settings

# gameplay
signal mow_attack_preparing(angle: float, prep_time: float)
signal stab_attack_preparing(from: Vector2, to: Vector2, prep_time: float)
signal whirlwind_attack_preparing(angle: float, reversed: bool, prep_time: float)
signal player_cut
signal butter_height_changed(height: float)

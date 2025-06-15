extends Node3D

signal level_won

func _on_exit_area_3d_player_exited():
	level_won.emit()

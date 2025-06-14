extends Control

@export var warning_panel: PanelContainer

@onready var active_mines: Array = get_tree().get_nodes_in_group("mine")

func _ready() -> void:
	for mine in active_mines:
		mine.exploded.connect(_on_killed_by_mine)


func _on_killed_by_mine() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	warning_panel.show()


func _on_try_again_button_pressed() -> void:
	get_tree().reload_current_scene()

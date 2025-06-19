extends Control

@export var item_interaction_ray_cast : ItemInteractionRayCast3D
@export var pick_up_label : Label


func _on_item_found(_item : Item3D) -> void:
	pick_up_label.show()

func _on_item_lost(_item : Item3D) -> void:
	pick_up_label.hide()

func _ready():
	item_interaction_ray_cast.item_found.connect(_on_item_found)
	item_interaction_ray_cast.item_lost.connect(_on_item_lost)

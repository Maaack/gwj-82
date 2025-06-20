extends CharacterBody3D

signal killed

const minimum_distance_squared = 0.25

@export var move_speed : float = 50

var player_character : Node3D
var target_position : Vector3

func _ready():
	player_character = get_tree().get_first_node_in_group(&"player")

func _on_track_refresh_timer_timeout() -> void:
	if player_character:
		target_position = player_character.global_position
		# Keep height the same as starting height for now.
		target_position.y = global_position.y

func _process(delta: float) -> void:
	if global_position.distance_squared_to(target_position) > minimum_distance_squared:
		var move_direction = target_position - global_position 
		move_direction = move_direction.normalized()
		velocity = move_speed * delta * move_direction
		move_and_slide()

func _on_area_3d_body_entered(body):
	if body == player_character:
		body.immobile = true
		$Grabbed.play()
		killed.emit()

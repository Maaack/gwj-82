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
		var move_direction : Vector3 = target_position - global_position
		move_direction.y = 0
		var angle_to : float = Vector3.FORWARD.signed_angle_to(move_direction, Vector3.UP)
		var _angle_diff : float = angle_difference(%Pivot.rotation.y, angle_to)
		var rotate_amount = _angle_diff * delta
		%Pivot.rotate_y(rotate_amount)
		move_direction = move_direction.normalized()
		velocity = move_speed * delta * move_direction
		move_and_slide()

func _on_area_3d_body_entered(body):
	if body == player_character:
		body.immobile = true
		killed.emit()

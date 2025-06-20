extends Area3D

enum WarningLevel{
	LOW,
	MODERATE,
	SEVERE,
	}

const SEVERE_COLOR: Color = Color.RED
const MODERATE_COLOR: Color = Color.ORANGE
const LOW_COLOR: Color = Color.YELLOW

const SEVERE_DELAY: float = 0.2
const MODERATE_DELAY: float = 1.5
const LOW_DELAY: float = 3.0

@export var sfx: AudioStreamPlayer3D
@export var light: OmniLight3D
@export var timer: Timer

var low_distance_threshold: float = 8.0
var moderate_distance_threshold: float = 5.0
var severe_distance_threshold: float = 2.0
var closest_mine_distance: float

func _ready() -> void:
	var closest_mine = get_closest(get_overlapping_areas())
	closest_mine_distance = global_position.distance_to(closest_mine.global_position)
	
	if closest_mine_distance <= severe_distance_threshold:
		mine_warning(WarningLevel.SEVERE)

func get_closest(_mines_in_range: Array) -> Node3D:
	var closest: Node3D = null
	
	for mine in _mines_in_range:
		if closest == null:
			closest = mine
			continue
		else:
			var dist_to_mine = global_position.distance_to(mine.global_position)
			var dist_to_current_closest = global_position.distance_to(closest.global_position)
			if dist_to_mine < dist_to_current_closest:
				closest = mine
			else:
				continue
	return closest


func mine_warning(_severity: WarningLevel) -> void:
	match _severity:
		WarningLevel.SEVERE:
			light.light_color = SEVERE_COLOR
			timer.wait_time = SEVERE_DELAY


func _on_timer_timeout() -> void:
	pass # Replace with function body.

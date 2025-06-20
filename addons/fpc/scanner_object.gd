extends Area3D

enum WarningLevel{
	LOW,
	MODERATE,
	SEVERE,
	NONE,
	}

const SEVERE_COLOR: Color = Color.RED
const MODERATE_COLOR: Color = Color.ORANGE
const LOW_COLOR: Color = Color.YELLOW
const NONE_COLOR: Color = Color.GREEN

const SEVERE_DELAY: float = 0.3
const MODERATE_DELAY: float = 1
const LOW_DELAY: float = 1.5

@export var sfx: AudioStreamPlayer3D
@export var light: OmniLight3D
@export var timer: Timer

var low_distance_threshold: float = 4.0
var moderate_distance_threshold: float = 2.0
var severe_distance_threshold: float = 0.5
var closest_mine_distance: float
var mines: Array

func _ready() -> void:
	call_deferred("init_scanner")


func init_scanner() -> void:
	var mines = get_tree().get_nodes_in_group("mine")
	print("Mines: " + str(mines.size()))
	var closest_mine = get_closest(mines)
	print("Closest mine: " + str(closest_mine))
	if closest_mine != null:
		closest_mine_distance = global_position.distance_to(closest_mine.global_position)
	
	if closest_mine_distance <= severe_distance_threshold:
		mine_warning(WarningLevel.SEVERE)
	elif closest_mine_distance <= moderate_distance_threshold:
		mine_warning(WarningLevel.MODERATE)
	elif closest_mine_distance <= low_distance_threshold:
		mine_warning(WarningLevel.LOW)
	else:
		mine_warning(WarningLevel.NONE)
		return


func _physics_process(delta: float) -> void:
	mines = get_overlapping_areas()


func get_closest(_mines: Array) -> Node3D:
	var closest: Node3D = null
	
	for mine in _mines:
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
			timer.start()
		WarningLevel.MODERATE:
			light.light_color = MODERATE_COLOR
			timer.wait_time = MODERATE_DELAY
			timer.start()
		WarningLevel.LOW:
			light.light_color = LOW_COLOR
			timer.wait_time = LOW_DELAY
			timer.start()
		WarningLevel.NONE:
			light.light_color = NONE_COLOR
			light.show()
			light.light_energy = 1.0
			timer.stop()


func _on_timer_timeout() -> void:
	##TODO play sfx 
	light.show()
	print("Mine Warning!")
	await get_tree().create_timer(0.1).timeout
	light.hide()

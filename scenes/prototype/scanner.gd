extends Area3D

const MIN_SCAN_DELAY: float = 0.2
const MAX_SCAN_DELAY: float = 3.0

@export var scan_input: String = "scan_for_mine"
@export var sfx: AudioStreamPlayer3D
@export var delay: Timer
@export var mine_icon: TextureRect

var mines_in_range: Array = []
var closest_mine: Area3D:
	set(new_closest_mine):
		if new_closest_mine == closest_mine:
			return
		else:
			closest_mine = new_closest_mine
			prints("Current closest: " + str(closest_mine))
	get:
		return closest_mine

func _ready() -> void:
	mine_icon.self_modulate.a = 0
	delay.wait_time = MAX_SCAN_DELAY
	delay.start()
	delay.timeout.connect(scan)
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	if mines_in_range.size() > 0:
		closest_mine = get_closest(mines_in_range)
		var closest_mine_distance = global_position.distance_to(closest_mine.global_position)

		if closest_mine_distance < delay.wait_time:
			delay.wait_time = closest_mine_distance
		if closest_mine_distance < delay.time_left:
			delay.start()


func get_closest(mines:Array) -> Area3D:
	var closest_mine = mines.front()
	for mine in mines:
		if global_position.distance_to(mine.global_position) < global_position.distance_to(closest_mine.global_position):
			closest_mine = mine
	return closest_mine


func scan() -> void:
	var mines_in_range = get_overlapping_areas()
	match mines_in_range.size():
		0:
			delay.wait_time = MAX_SCAN_DELAY
			delay.start()
			return
		_:
			mine_icon.self_modulate.a = 1
			var icon_tween = get_tree().create_tween()
			icon_tween.tween_property(mine_icon,"self_modulate:a",0,delay.wait_time/2)
			delay.start()
			sfx.play()
	printt("Mines in range: " + str(mines_in_range))
	prints("Delay wait time: " + str(delay.wait_time))


func _on_area_entered(area: Area3D) -> void:
	if !mines_in_range.has(area):
		mines_in_range.append(area)
		if delay.is_stopped():
			scan()


func _on_area_exited(area: Area3D) -> void:
	mines_in_range.erase(area)

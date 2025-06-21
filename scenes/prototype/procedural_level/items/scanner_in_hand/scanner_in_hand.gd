extends Node3D

@export var area: Area3D
@export var beep: AudioStreamPlayer
@export var flash: TextureRect

var min_distance := 10.0  # Max detection radius
var beep_timer := 0.0
var flash_timer := 0.0
var beep_interval := 1.0
var last_intensity := 0.0
var killed: bool = false

func _ready() -> void:
	var killed_warning = get_tree().get_first_node_in_group("killed_warning")
	killed_warning.connect("killed",_on_killed)

func _process(delta):
	if killed:
		return
	var closest_dist = get_closest_mine_distance()
	
	if closest_dist < min_distance:
		var intensity = 1.0 - clamp(closest_dist / min_distance, 0.0, 1.0)
		beep_interval = lerp(1.0, 0.1, intensity)  # Faster beep as you get closer
		
		beep_timer -= delta
		flash_timer += delta
		
		if beep_timer <= 0:
			beep.play()
			beep_timer = beep_interval
			flash_timer = 0.0
			last_intensity = intensity
		
		update_flash(last_intensity)
	else:
		flash.visible = false
		beep_timer = 0.0

func get_closest_mine_distance() -> float:
	var closest = min_distance
	for area in area.get_overlapping_areas():
		var raw_dist = global_position.distance_to(area.global_position)
		var dist = max(0.0, raw_dist - 1.5)
		if dist < closest:
			closest = dist
	print(closest)
	return closest

func update_flash(intensity: float):
	# Update color from yellow (1,1,0) to red (1,0,0)
	var color = Color(1, 1 - intensity, 0)
	var alpha = clamp(1.0 - (flash_timer / beep_interval), 0.0, 1.0)
	color.a = alpha
	flash.self_modulate = color
	flash.visible = alpha > 0.01

func _on_killed() -> void:
	killed = true

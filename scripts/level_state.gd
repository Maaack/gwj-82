class_name LevelState
extends Resource

@export var zones : Array[ZoneState]
@export var mines_removed : Array[Vector3]
@export var tutorial_read : bool = false
@export var starting_ghosts : int = 1

func get_zone_state(builder_name : StringName) -> ZoneState:
	for zone in zones:
		if zone.builder_name == builder_name:
			return zone
	var _new_zone = ZoneState.new()
	_new_zone.builder_name = builder_name
	zones.append(_new_zone)
	return _new_zone

extends Node

#@onready var spawn = preload("res://Global/spawn_unit.tscn")

var deployment_points = 1000
var supplies = 1000

#func spawn_unit(position):
#	var path = get_tree().get_root().get_node("World/UI")
#	var hasSpawned = false
#	for i in path.get_child_count():
#		if "SpawnUnit" in path.get_child(i).name:
#			hasSpawned = true
#	if hasSpawned == false:
#		var spawnUnit = spawn.instantiate()
#		spawnUnit.housePosition = position
#		path.add_child(spawnUnit)

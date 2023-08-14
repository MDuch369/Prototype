#extends Node2D
#
#@onready var unit = preload("res://unit.tscn")
#var housePosition = Vector2(300, 300)
#
#func _on_yes_pressed():
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#	var randomPositionx = rng.randi_range(-50, 50)
#	var randomPositiony = rng.randi_range(-50, 50)
#	
#	var unitPath = get_tree().get_root().get_node("World/Units")
#	var worldPath = get_tree().get_root().get_node("World")
#	var unit1 = unit.instantiate()
#	
#	unit1.position = housePosition + Vector2(randomPositionx, randomPositiony)
#	unitPath.add_child(unit1)
#	worldPath.get_units()
#
#func _on_no_pressed():
#	queue_free()

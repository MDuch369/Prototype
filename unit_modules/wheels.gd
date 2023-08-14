extends Propulsion

#var crew = []
#@onready var driver = true


func _ready():
	super()
	type = "wheels"
#	crewed = true
	max_resources = 500.0
	current_resources = 500.0
	resource_transfer_cost = 1.0
	resource_usage = 1.0
	required_crew = 1
	movement_speed = 150.0
	rotation_speed = PI / 3


#func embark_driver():
#	driver = true


#func disembark_driver():
#	driver = false


func _on_moving_state_physics_processing(delta):
	pass # Replace with function body.


func _on_rotating_state_physics_processing(delta):
	pass # Replace with function body.

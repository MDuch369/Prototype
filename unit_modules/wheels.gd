extends Propulsion


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


func _on_moving_state_physics_processing(delta):
	pass # Replace with function body.


func _on_rotating_state_physics_processing(delta):
	pass # Replace with function body.

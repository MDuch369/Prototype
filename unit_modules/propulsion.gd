class_name Propulsion
extends ModuleResource

@export var movement_speed: float
@export var rotation_speed: float
#var crew_pos_1: CrewPosition = CrewPosition.DRIVER
@onready var target = position
@onready var _state_chart: StateChart = $"../../StateChart"
#@onready var collision_ray = $"../../RayCast2D"
#@onready var navigation_agent: NavigationAgent2D = $"../../NavigationAgent2D"
#var follow_cursor = false


func _ready():
	resource = "fuel"


func _on_rotating_state_physics_processing(delta):
	if is_instance_valid(active_order):
		var angle = get_angle_to(active_order.global_position)
		if  angle > 0.015 and angle <= PI:
			unit.rotate(rotation_speed * delta)
			current_resources -= resource_usage * delta
		elif  angle < -0.015 and angle > -PI:
			unit.rotate(-1 * rotation_speed * delta)
			current_resources -= resource_usage * delta
		elif active_order.type == active_order.Type.MOVE:
			_state_chart.send_event("move")
		else:
			finish_order()


func _on_moving_state_physics_processing(delta):
	var rotation_angle
#	if follow_cursor == true:
#		target = get_global_mouse_position()
	if (
			is_instance_valid(active_order) 
			and unit.position.distance_to(active_order.global_position) > 15
		):
		rotation_angle = get_angle_to(active_order.global_position)
		if is_rotated(rotation_angle, delta) == true:
			#check_collisions()
			move(active_order.global_position, delta)
		else:
			_state_chart.send_event("rotate")
	else:
		finish_order()


func move(mov_target, delta):
	if target is Vector2:
		unit.velocity = unit.position.direction_to(mov_target) * movement_speed
	else:
		unit.velocity = unit.position.direction_to(active_order.global_position) * movement_speed
	var motion = unit.velocity * delta
	unit.move_and_collide(motion)
	current_resources -= resource_usage * delta


func is_rotated(angle, delta):
	if  angle > 0.015 or angle < -0.015:
		return false
#		_state_chart.send_event("rotate")
	else:
		return true


func finish_order():
	if is_instance_valid(active_order):
		active_order.clear()
		orders.set_order()
		if orders.order_array.is_empty():
			_state_chart.send_event("stop")
			status = "idle"


#func check_collisions():
#	var target_vector = unit.global_position - active_order.global_position
#	collision_ray.enabled = true
#	if collision_ray.is_colliding():
#		var perp = target_vector.orthogonal().normalized() * 200
#		var point = collision_ray.get_collision_point()
#		var avoid_target = point + perp
#
#		### HACK!!! AAAAAA!!!!
#		if collision_ray.get_collider().get_node("Modules").get_node("Propulsion").status == "moving":
#			await get_tree().create_timer(0.5).timeout
#		else:
#			var ord = order.instantiate()
#			ord.unit = unit
#			ord.type = "move"
#			ord.global_position = avoid_target
#			var world = get_tree().get_root().get_node("World")
#			world.add_child(ord)
#			unit.orders.push_front(ord)
#			unit.set_order()
#		### HACK END!!


class_name InfantryPropulsion
extends Module

@export var movement_speed: float
@export var rotation_speed: float
@onready var _state_chart: StateChart = $"../../StateChart"
@onready var target = position
#@onready var unit = $"../.."

var follow_cursor = false


func _on_rotating_state_physics_processing(delta):
	if is_instance_valid(active_order):
		var angle = get_angle_to(active_order.global_position)
		if  angle > 0.015 and angle <= PI:
			if angle < rotation_speed * delta:
				unit.rotate(angle)
			else:
				unit.rotate(rotation_speed * delta)
		elif  angle < -0.015 and angle > -PI:
			if -angle < rotation_speed * delta:
				unit.rotate(angle)
			else:
				unit.rotate(-rotation_speed * delta)
		elif (
				active_order.type == active_order.Type.MOVE
				or active_order.type == active_order.Type.EMBARK
			):
			print("moving")
			_state_chart.send_event("move")
		else:
			finish_order()


func _on_moving_state_physics_processing(delta):
	var rotation_angle
#	if follow_cursor == true:
#		target = get_global_mouse_position()
	if (
			is_instance_valid(active_order) 
			and unit.position.distance_to(active_order.global_position) > 5
		):
		rotation_angle = get_angle_to(active_order.global_position)
		if is_rotated(rotation_angle, delta) == true:
			#check_collisions()
			if active_order.type == Order.Type.EMBARK: 
				move_and_embark(delta)
			else:
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
#	current_resources -= resource_usage * delta


func move_and_embark(delta):
	unit.velocity = unit.position.direction_to(active_order.target_unit.global_position) * movement_speed
	var motion = unit.velocity * delta
	var collision = unit.move_and_collide(motion)
	if is_instance_valid(collision): 
		if collision.get_collider() == active_order.target_unit:
			collision.get_collider().transport.embark(unit)
			unit.get_node("Orders").clear()
#		print("collision :")
#		print(collision.get_collider())
#		print("target :")
#		print(active_order.target_unit)


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


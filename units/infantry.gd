class_name Infantry
extends BasicUnit

signal in_range
#signal embarked
#var closing = false
#var attacking = false
var active_transfers = []
@onready var target = position
@onready var anim = $"AnimationPlayer"
#@onready var navigation_agent = $NavigationAgent2D


func _ready():
	super()
	add_to_group("non combat", true)
	add_to_group("friendly", true)
	add_to_group("crew", true)
	add_to_group("transportable", true)
#	navigation_agent.path_desired_distance = 4.0
#	navigation_agent.target_desired_distance = 4.0
#	call_deferred("actor_setup")


#func actor_setup():
#	await get_tree().physics_frame
#	#set_movement_target(movement_target_position)
	
#func set_movement_target(movement_target):
#	navigation_agent.target_position = movement_target


func destroyed():
	active = false


func hit():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, 4)
	if result > 1:
		destroyed()

#func embark(transport):
#	pass


#func _physics_process(delta):
#	if follow_cursor == true and attacking == false:
#		if selected:
#			target = get_global_mouse_position()
#
#	var rotation_angle
#	if position.distance_to(target) > 15:
#		rotation_angle = get_angle_to(target)
#		if is_rotated(rotation_angle) == true:
#			move(target, delta)
#			anim.play("walk")
#	else:
#		anim.stop()
#	if closing == true:
#		if position.distance_to(target) < 15:
#			closing = false
#			target = position
#			in_range.emit()


#func is_rotated(angle):
#	if  angle > 0.05:
#		if angle <= PI:
#			rotate(rotation_speed / 60)
#	elif  angle < -0.05:
#		if angle > -PI:
#			rotate(-1 * rotation_speed / 60)
#	else:
#		return true

#func move(target, delta):
#	if target is Vector2:
#		velocity = position.direction_to(target) * speed
#	else:
#		velocity = position.direction_to(target.position) * speed
#	var motion = velocity * delta
#	move_and_collide(motion)


#func set_selected(value):
#	selected = value
#	box.visible = value
#	



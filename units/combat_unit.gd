extends BasicUnit

signal in_range
const MAX_CREW: int = 4
const MIN_CREW: int = 2
var crew: int = 4
var closing := false
#var attacking := false
#var selected_unit = null
var active_transfers: Array = []
@onready var propulsion = $Modules/Propulsion
@onready var weapon = $Modules/Cannon
@onready var smoke = $SmokeBig
@onready var anim = $"AnimationPlayer"
@onready var target = position


func _ready():
	super()
	in_range.connect(Callable(weapon, "engage"))
	add_to_group("combat", true)
	add_to_group("friendly", true)
	icon = "tank"
	mental_state.RELAXED
	unit_name = "Tank"
	icon = load("res://assets/custom/tact_unit_rect.png")
	#smoke.visible = false
	#_mouse_entered.connect(Callable(world, "on_entered"))
	#mouse_exited.connect(Callable(world, "on_exited"))
	#set_pickable(true)
	#input_event.connect(Callable(world, "on_input_event"))
	#navigation_agent.path_desired_distance = 4.0
	#navigation_agent.target_desired_distance = 4.0
	#call_deferred("actor_setup")


#func actor_setup():
#	await get_tree().physics_frame
#	#set_movement_target(movement_target_position)
#	
#func set_movement_target(movement_target):
#	navigation_agent.target_position = movement_target

#func set_order():
#	if orders.is_empty() != true:
#		#print("set")
#		var order = orders[0]
#		if order.type == "attack":
#			weapon.active_order = order
#			weapon.current_target = order.target_unit
#			weapon.attack()
#		elif order.type == "move":
#			propulsion.active_order = order
#			propulsion.target = order.global_position
#			propulsion.status = "moving"
#			#propulsion.set_movement_target(order.position)
#		elif order.type == "rotate":
#			propulsion.active_order = order
#			propulsion.target = order.global_position
#			propulsion.status = "rotating"
#		elif order.type == "supply":
#			cargo.active_order = order
#			cargo.current_target = order.target_unit

# movement
func is_rotated(angle):
	if  angle > 0.05:
		if angle <= PI:
			rotate(propulsion.rotation_speed / 60)
	elif  angle < -0.05:
		if angle > -PI:
			rotate(-1 * propulsion.rotation_speed / 60)
	else:
		return true
	

# damage
func destroyed():
	active = false
	#THIS IS A HACK
	await get_tree().create_timer(0.3).timeout
	smoke.visible = true


func hit():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, 10)
	if result > 1:
	#if result > 9:
		destroyed()


#func set_parent_unit(par):
#	parent_unit = par

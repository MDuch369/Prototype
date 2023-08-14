extends BasicUnit


const MAX_CREW = 1
const MIN_CREW = 1
var crew = 1
var closing = false
var selected_unit = null
var active_transfers = []
@onready var propulsion = $Modules/Propulsion
@onready var cargo = $Modules/Cargo
@onready var smoke = $SmokeBig
@onready var anim = $"AnimationPlayer"
@onready var target = position

#var rotation_angle
#var direction

func _ready():
	super()
	smoke.visible = false
	add_to_group("non combat", true)
	add_to_group("friendly", true)
	add_to_group("supplier", true)
	#input_event.connect(Callable(world, "on_input_event"))

#func _input_event(viewport, event, shape_idx):
#	input_event.emit(event)
#func _mouse_enter():
#	_mouse_entered.emit(self)
#func _mouse_exit():
#	mouse_exited.emit()

#func _physics_process(delta):
#	if follow_cursor == true:
#		if selected:
#			target = get_global_mouse_position()
##			anim.play("walk")
#	rotation_angle = get_angle_to(target)
#	if position.distance_to(target) > 15:
#		if  rotation_angle > 0.05:
#			if rotation_angle <= PI:
#				rotate(rotation_speed / 60)
#		elif  rotation_angle < -0.05:
#			if rotation_angle > -PI:
#				rotate(-1 * rotation_speed / 60)
#		else:
#			velocity = position.direction_to(target) * speed
#			var motion = velocity * delta
#			#move_and_slide()
#			move_and_collide(motion)
#	else:
#		anim.stop()

#func set_order():
#	#print(orders)
#	if orders.is_empty() != true:
#		#print("set")
#		var order = orders[0]
#		if order.type == "supply":
#			cargo.active_order = order
#			cargo.current_target = order.target_unit
#		elif order.type == "move":
#			propulsion.active_order = order
#			propulsion.target = order.position
#			propulsion.status = "moving"


func destroyed():
	active = false
	smoke.visible = true


func hit():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, 4)
	if result > 1:
		destroyed()

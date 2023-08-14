extends CharacterBody2D

# unit
@export var selected = false
var orders = []
var active = true
var follow_cursor = false
signal _mouse_entered(unit)

# modules
@onready var propulsion
@onready var weapon
@onready var cargo
@onready var module
var crew

@onready var world = $"../.."
@onready var smoke = $SmokeBig
@onready var box = $"Box"
@onready var anim = $"AnimationPlayer"
@onready var target = position
signal in_range
var closing = false
var attacking = false
var selected_unit = null
var active_transfers = []

func _ready():
	_mouse_entered.connect(Callable(world, "on_entered"))
	mouse_exited.connect(Callable(world, "on_exited"))
	in_range.connect(Callable(weapon, "engage"))
	smoke.visible = false
	set_pickable(true)
	set_selected(selected)
	add_to_group("units", true)
	add_to_group("combat", true)
	add_to_group("friendly", true)


func _mouse_enter():
	_mouse_entered.emit(self)
func _mouse_exit():
	mouse_exited.emit()

func set_order():
	if orders.is_empty() != true:
		var order = orders[0]
		if order.type == "attack":
			weapon.active_order = order
			weapon.current_target = order.target_unit
		elif order.type == "move":
			propulsion.active_order = order
			propulsion.target = order.position
			propulsion.status = "moving"

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

func move(target, delta):
	if target is Vector2:
		velocity = position.direction_to(target) * propulsion.speed
	else:
		velocity = position.direction_to(target.position) * propulsion.speed
	var motion = velocity * delta
	move_and_collide(motion)
	propulsion.current_resources -= propulsion.resource_usage * delta
	
func set_selected(value):
	selected = value
	box.visible = value

func stop():
	target = position
	weapon.stop_attacking()

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

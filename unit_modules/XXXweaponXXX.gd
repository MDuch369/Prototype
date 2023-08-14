#class_name Weapon
extends ModuleResource

var weapon_name: String
var weapon_range: float
var strength: float
var armour_piercing: float
var accuracy: float
var turret_rotation_speed: float
var muzzle_velocity: float
var reload_time: float
var series_length: int
var series_pause: float
var rate_of_fire: float
var max_ammo: int
var current_ammo: int
var current_target = null
var target_distance: float
var target_angle: float
var muzzle
@onready var _state_chart: StateChart = $"../../StateChart"
@onready var projectile = preload("res://projectile.tscn")
@onready var anim = $"../../AnimationPlayer"
#@onready var unit = $"../.."
#@onready var turret = $TankTurret

func _ready():
	resource = "ammo"

func _physics_process(delta):
	if active_order != null: 
		if status == "rotate_turret":
			if target_angle > 0.05 and target_angle <= PI:
				rotate(turret_rotation_speed * delta)
			elif target_angle < -0.05 and target_angle > -PI:
				rotate(-1 * turret_rotation_speed * delta)
			check_rotation()
		elif status == "close_range":
			var new_target = unit.position.move_toward(current_target.position, target_distance - weapon_range)
			unit.closing = true
			unit.target = new_target
	if status == "turret_to_neutral":
		var angle = rotation
		if angle > 0.05 and angle <= PI:
			rotate(-turret_rotation_speed * delta)
		elif angle < -0.05 and angle > -PI:
			rotate(turret_rotation_speed * delta)
		turret_to_neutral()


func attack():
	check_rotation()


func check_rotation():
	target_angle = get_angle_to(current_target.position)
	if target_angle < 0.05 and target_angle > -0.05:
		_state_chart.send_event("firing")
		status = "in_position"
		engage()
	else:
		_state_chart.send_event("rotating")
		status = "rotate_turret"


func engage():
	while current_target.active == true:
#		await fire()
		await get_tree().create_timer(series_pause).timeout
		if current_ammo == 0:
			await reload()
	turret_to_neutral()


func projectile_in_flight():
	for node in get_children():
		if node.name == "projectile":
			return true
		else:
			return false


#func fire():
#	var n = 0
#	while n < series_length:
#		n += 1
#		current_ammo -= 1
#		var proj = projectile.instantiate()
#		proj.add_collision_exception_with(unit)
#
#		add_child(proj)
#		proj.type = weapon_name
#		proj.position = muzzle.position
#		proj.speed = muzzle_velocity
#		proj.weapon_range = weapon_range
#		proj.strength = strength
#		proj.firing_position = global_position 
#		proj.target = current_target
#		proj.fired = true
#		anim.play("tank_fire")
#		_state_chart.send_event("fired")
#		await get_tree().create_timer(60.0 / rate_of_fire).timeout
#		#fired.emit()


func reload():
	current_resources -= 1
	await get_tree().create_timer(reload_time).timeout
	current_ammo += 1
	_state_chart.send_event("loaded")


func turret_to_neutral():
	if rotation > 0.05 or rotation < -0.05:
		status = "turret_to_neutral"
	else:
		disengage()


func disengage():
	active_order.clear()
	current_target = null
	status = "idle"


func _on_firing_state_entered():
	var n = 0
	while n < series_length:
		n += 1
		current_ammo -= 1
		var proj = projectile.instantiate()
		proj.add_collision_exception_with(unit)
		
		add_child(proj)
		proj.type = weapon_name
		proj.position = muzzle.position
		proj.speed = muzzle_velocity
		proj.weapon_range = weapon_range
		proj.strength = strength
		proj.firing_position = global_position 
		proj.target = current_target
		proj.fired = true
		anim.play("tank_fire")
		_state_chart.send_event("fired")
		await get_tree().create_timer(60.0 / rate_of_fire).timeout
		#fired.emit()


func _on_rotating_state_physics_processing(delta):
	if target_angle > 0.05 and target_angle <= PI:
		rotate(turret_rotation_speed * delta)
	elif target_angle < -0.05 and target_angle > -PI:
		rotate(-1 * turret_rotation_speed * delta)
	check_rotation()

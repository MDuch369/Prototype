extends Weapon

var commander := true
var gunner := true
@onready var turret = $TankTurret
#@onready var muzzle = $TankTurret/TankFire
#@onready var anim = $"../../AnimationPlayer"
#@onready var unit = $"../.."
#var weapon_name := "Machine Gun"
#var current_target = null
#var target_distance
#var target_angle
#@onready var projectile = preload("res://projectile.tscn")


func _ready():
	muzzle = $TankTurret/TankFire
#	weapon_name = "Machine Gun"
	required_crew = 1
	weapon_range = 500.0
	strength = 2
	reload_time = 3.0
	muzzle_velocity = 700.0
	turret_rotation_speed = PI
	series_length = 5
#	series_pause = 1.0
	rate_of_fire = 600.0
#	max_ammo = 1000
#	current_ammo = max_ammo

func embark_crew():
	gunner = true
	commander = true

func disembark_crew():
	gunner = false
	commander = false


#func _physics_process(delta):
#	if active_order != null: 
#		if status == "rotate_turret":
#			if target_angle > 0.05 and target_angle <= PI:
#				rotate(turret_rotation_speed * delta)
#			elif target_angle < -0.05 and target_angle > -PI:
#				rotate(-1 * turret_rotation_speed * delta)
#			check_rotation()
#		elif status == "close_range":
#			var new_target = unit.position.move_toward(current_target.position, target_distance - weapon_range)
#			unit.closing = true
#			unit.target = new_target
#	if status == "turret_to_neutral":
#		var angle = rotation
#		if angle > 0.05 and angle <= PI:
#			rotate(-turret_rotation_speed * delta)
#		elif angle < -0.05 and angle > -PI:
#			rotate(turret_rotation_speed * delta)
#		turret_to_neutral()


#func attack():
#	check_rotation()
#
#
#func check_rotation():
#	target_angle = get_angle_to(current_target.position)
#	if target_angle < 0.05 and target_angle > -0.05:
#		status = "in_position"
#		engage()
#	else:
#		status = "rotate_turret"
#
#
#func engage():
#	while current_target.active == true:
#		await fire()
#		await get_tree().create_timer(series_pause).timeout
#		if current_ammo == 0:
#			await reload()
#	turret_to_neutral()
#
#
#func projectile_in_flight():
#	for node in get_children():
#		if node.name == "projectile":
#			return true
#		else:
#			return false
#
#
#func fire():
#	var n = 0
#	while n < series_length:
#		n += 1
#		current_ammo -= 1
#		var proj = projectile.instantiate()
#		proj.add_collision_exception_with(unit)
#
#		add_child(proj)
#		proj.type = "machine gun"
#		proj.position = muzzle.position
#		proj.speed = muzzle_velocity
#		proj.weapon_range = weapon_range
#		proj.strength = strength
#		proj.firing_position = global_position 
#		proj.target = current_target
#		proj.fired = true
#		anim.play("tank_fire")
#		await get_tree().create_timer(60.0 / rate_of_fire).timeout
#		#fired.emit()
#
#
#func reload():
#	current_resources -= 1
#	await get_tree().create_timer(reload_time).timeout
#	current_ammo += 1
#
#
#func turret_to_neutral():
#	if rotation > 0.05 or rotation < -0.05:
#		status = "turret_to_neutral"
#	else:
#		disengage()
#
#
#func disengage():
#	active_order.clear()
#	current_target = null
#	status = "idle"

class_name Weapon
extends ModuleResource

var active_projectiles: Array[Projectile] = []
var angle_to_target := 0.0
var max_ready_ammo: int
var muzzle: Node
var muzzle_velocity: float
var rate_of_fire: float
var ready_ammo: int
var reload_time: float
var series_length: int
var strength: float
var target: Unit
var turret_rotation_speed: float
var weapon_range: float
#var max_reserve_ammo: int
#var reserve_ammo: int
#var max_magazine_ammo: int 
#var magazine_ammo: int
@onready var reload_timer = $ReloadTimer
@onready var _state_chart: StateChart = $"../../StateChart"
#@onready var _state_chart: StateChart = $WeaponStateChart
@onready var projectile: PackedScene = preload("res://unit_modules/projectile.tscn")


func _on_rotating_state_physics_processing(delta) -> void:
	if angle_to_target > 0.05 and angle_to_target <= PI:
		rotate(turret_rotation_speed * delta)
		update_angle_to_target()
	elif angle_to_target < -0.05 and angle_to_target > -PI:
		rotate(-1 * turret_rotation_speed * delta)
		update_angle_to_target()
	elif active_projectiles.is_empty() and not target == null:
		_state_chart.send_event("shoot")
	else:
		_state_chart.send_event("stop rotating")


func _on_shooting_state_physics_processing(delta) -> void:
	if active_projectiles.is_empty():
		fire(target)
		if ready_ammo == 0 and has_ammo():
			_state_chart.send_event("reload")
		else:
			_state_chart.send_event("ammo exhausted")
		
	if target_destroyed(target):
		target = null
		angle_to_target = -rotation
		_state_chart.send_event("rotate turret")
		active_order.clear()


func check_range(distance: float) -> bool: 
	if distance > weapon_range:
		return false
	return true


func check_rotation(target_angle: float) -> bool:
	if (
		target_angle > 0.05 and target_angle <= PI
		or target_angle < -0.05 and target_angle > -PI
	):
		return false
	return true


func rotate_vehicle(target_angle: float) -> void:
	## decide if the method should be placed here, 
	## or should be handled as a unit order
	pass


func move_closer() -> void:
	## decide if the method should be placed here, 
	## or should be handled as a unit order
	pass


func check_turret_rotation(target_angle: float) -> bool:
	if (
		target_angle > 0.05 and target_angle <= PI
		or target_angle < -0.05 and target_angle > -PI
	):
		return false
	return true


func create_projectile(target: Unit) -> void:
	var proj = projectile.instantiate()
	proj.add_collision_exception_with(unit)
	unit.world.add_child(proj) ## the projectile should probably be child of the world
	active_projectiles.push_back(proj)
	#proj.type = weapon_name
	proj.position = muzzle.global_position
	proj.rotation = muzzle.global_rotation
	proj.speed = muzzle_velocity
	proj.weapon_range = weapon_range
	proj.strength = strength
	proj.firing_position = global_position 
	proj.target = target
	proj.fired = true


func fire(target: Unit) -> void:
	var n = 0
	while n < series_length and ready_ammo > 0:
		n += 1
		create_projectile(target)
		ready_ammo -= 1
		if series_length > 1:
			await get_tree().create_timer(60.0 / rate_of_fire).timeout


func target_destroyed(target:Unit) -> bool:
	return not target.active 


func has_ammo() -> bool:
	return current_resources > 0


func update_angle_to_target() -> void:
	if not target == null:
		angle_to_target = get_angle_to(target.position)
	else:
		angle_to_target = -rotation


func engage_target() -> void:
	var pos = global_position
	var target_pos = target.global_position
	update_angle_to_target()
	
	if not check_range(pos.distance_to(target_pos)):
		if not check_rotation(angle_to_target):
			rotate_vehicle(angle_to_target)
		move_closer()
	elif not check_turret_rotation(angle_to_target):
		_state_chart.send_event("rotate turret")
	else: 
		_state_chart.send_event("shoot")


func _on_shooting_state_entered() -> void:
	fire(target)
	if ready_ammo == 0 and has_ammo():
		_state_chart.send_event("reload")
	else:
		_state_chart.send_event("ammo exhausted")
	
	if target_destroyed(target) or target == null:
		angle_to_target = 0.0
		_state_chart.send_event("rotate turret")
		active_order.clear()


func _on_reload_timer_timeout() -> void:
	ready_ammo = max_ready_ammo
	current_resources -= max_ready_ammo
	_state_chart.send_event("loaded")
	if not target == null:
		_state_chart.send_event("shoot")


func _on_loading_state_entered() -> void:
	reload_timer.start(reload_time)

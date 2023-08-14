extends Weapon

func _ready():
	muzzle = get_node("Autocannon").get_node("TankFire")
	max_ready_ammo = 500
	muzzle_velocity = 500
	rate_of_fire = 300.0
	ready_ammo = max_ready_ammo
	reload_time = 1.0
	series_length = 3
	strength = 5.0
	turret_rotation_speed = PI
	weapon_range = 500.0

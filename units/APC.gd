extends BasicUnit

signal in_range
const MAX_CREW: int = 2
const MIN_CREW: int = 1
var crew: int = 2
var crew_driver := true
var crew_commander := true
var closing := false
#var attacking := false
#var selected_unit = null
var active_transfers: Array = []
@onready var propulsion = $Modules/Propulsion
@onready var weapon = $Modules/MachineGun
@onready var smoke = $SmokeBig
@onready var anim = $"AnimationPlayer"
@onready var target = position


func _ready():
	super()
	in_range.connect(Callable(weapon, "engage"))
	add_to_group("combat", true)
	add_to_group("friendly", true)
	add_to_group("transport", true)
	icon = "apc"
	unit_name = "APC"



func is_rotated(angle):
	if  angle > 0.05:
		if angle <= PI:
			rotate(propulsion.rotation_speed / 60)
	elif  angle < -0.05:
		if angle > -PI:
			rotate(-1 * propulsion.rotation_speed / 60)
	else:
		return true
	

func disembark_crew():
	pass


# damage
func destroyed():
	active = false
	#THIS IS A HACK
	await get_tree().create_timer(0.3).timeout
	smoke.visible = true


func hit(strength):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, 10) + strength
	if result > 10:
	#if result > 9:
		destroyed()

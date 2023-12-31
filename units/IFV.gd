extends BasicUnit

signal in_range
const MAX_CREW: int = 3

@onready var crew_list: Array[Unit] = [$Modules/Driver, $Modules/Gunner, $Modules/Commander]
var closing := false
var active_transfers: Array = []
#var selected_unit = null
var ui
#@onready var _state_chart: StateChart = $StateChart
#@onready var ui = world.get_node("UI")
@onready var propulsion = $Modules/Tracks
@onready var secondary_propulsion = null
@onready var main_weapon = $Modules/Autocannon
@onready var secondary_weapons = null
@onready var transport = $Modules/Transport
@onready var cargo = null
@onready var smoke = $SmokeBig
@onready var anim = $"AnimationPlayer"
@onready var target = position


func _ready():
	super()
	ui = world.get_node("UI")
	in_range.connect(Callable(main_weapon, "engage"))
	add_to_group("combat", true)
	add_to_group("friendly", true)
	add_to_group("transport", true)
	icon = "ifv"
	unit_name = "IFV"
	experience = 15.0
	maintenance = 75.0



func is_rotated(angle):
	if  angle > 0.05:
		if angle <= PI:
			rotate(propulsion.rotation_speed / 60)
	elif  angle < -0.05:
		if angle > -PI:
			rotate(-1 * propulsion.rotation_speed / 60)
	else:
		return true


func embark_crew(unit):
	if crew_list.size() <= MAX_CREW:
		crew_list.push_back(unit)
		unit.PROCESS_MODE_DISABLED
#		unit.global_position = global_position
		unit.visible = false
#	crew_positions["driver"] = CrewStatus.EMPTY
#	crew_positions["gunner"] = CrewStatus.EMPTY
#	crew_positions["commander"] = CrewStatus.EMPTY
#	print(crew_list.size())
#	print(crew_list[0])
	if crew_list.size() == 1:
		embark_driver(unit)
	elif crew_list.size() == 2:
		embark_gunner(unit)
	elif crew_list.size() == 3:
		embark_commander(unit)


func embark_driver(unit):
	propulsion._state_chart.send_event("crew enabled")
	ui._state_chart.send_event("enable driver")


func embark_gunner(unit):
	main_weapon._state_chart.send_event("crew enabled")
	ui._state_chart.send_event("enable gunner")


func embark_commander(unit):
	
	ui._state_chart.send_event("enable commander")


func disembark_crew():
	var n = 0
	for unit in crew_list:
		unit.PROCESS_MODE_INHERIT
#		print(unit)
		unit.global_position = global_position + Vector2(25 * n, 50)
		n += 1
		unit.visible = true
	disembark_driver()
	disembark_gunner()
	disembark_commander()
	crew_list.clear()
#	print(crew_list.size())


func disembark_driver():
	propulsion._state_chart.send_event("crew disabled")
	ui._state_chart.send_event("disable driver")


func disembark_gunner():
	main_weapon._state_chart.send_event("crew disabled")
	ui._state_chart.send_event("disable gunner")


func disembark_commander():
	
	ui._state_chart.send_event("disable commander")

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

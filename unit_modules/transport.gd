extends Module

const TRANSPORT_CAPACITY := 12
var embarked_units: Array[BasicUnit] = []
#var transported_units: Array = []


func _ready():
	for child in get_children():
		embarked_units.push_back(child)
		print(child)
	print(embarked_units)

func embark(unit):
	var units = unit.units
	if embarked_units.size() <= TRANSPORT_CAPACITY:
		embarked_units.push_back(unit)
		unit.set_process_mode(ProcessMode.PROCESS_MODE_DISABLED)
#		unit.global_position = global_position
		unit.reparent(self)
		unit.visible = false
	
func disembark():
	var units = unit.units
	var n = 0
	for embarked in embarked_units:
		embarked.set_process_mode(ProcessMode.PROCESS_MODE_INHERIT)
		embarked.global_position = global_position + Vector2(25 * n, 50)
		embarked.visible = true
		embarked.reparent(units)
		n += 1
	embarked_units.clear()
	print(embarked_units)

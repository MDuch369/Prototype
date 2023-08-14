extends Module

const TRANSPORT_CAPACITY := 12
var transported_units: Array[BasicUnit] = []
#var transported_units: Array = []

func embark(unit):
	if transported_units.size() <= TRANSPORT_CAPACITY:
		transported_units.push_back(unit)
		unit.PROCESS_MODE_DISABLED
#		unit.global_position = global_position
		unit.visible = false
	
func disembark():
	for unit in transported_units:
		unit.PROCESS_MODE_INHERIT
		unit.global_position = global_position + Vector2(50, 50)
		unit.visible = true
	transported_units.clear()

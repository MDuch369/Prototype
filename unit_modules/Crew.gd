extends Module

#const MAX_CREW: int = 3
##const MIN_CREW: int = 1
enum CrewPos {
	DRIVER,
	GUNNER,
	COMMANDER,
	LOADER,
}
#var crew_list: Array[CrewPos] = [CrewPos.DRIVER, CrewPos.GUNNER, CrewPos.COMMANDER]
#
#func embark_crew(unit):
#	if crew_list.size() <= MAX_CREW:
#		crew_list.push_back(unit)
#		unit.PROCESS_MODE_DISABLED
##		unit.global_position = global_position
#		unit.visible = false
#	propulsion.crewed = true
#	main_weapon.crewed = true
#
#func disembark_crew():
#	for unit in crew_list:
#		unit.PROCESS_MODE_INHERIT
#		unit.global_position = global_position + Vector2(50, 50)
#		unit.visible = true
#	crew_list.clear()
#	propulsion.crewed = false
#	main_weapon.crewed = false	
#	_state_chart.send_event("driver inactivated")
#	_state_chart.send_event("gunner inactivated")
#	_state_chart.send_event("commander inactivated")

func _ready():
	pass

extends Node2D

# Crew
#const MAX_CREW: int = 3
#enum CrewStatus {
#	ACTIVE,
#	INACTIVE,
#	EMPTY,
#}
#var crew_positions = {
#	"driver" : CrewStatus.ACTIVE,
#	"gunner" : CrewStatus.ACTIVE,
#	"commander" : CrewStatus.ACTIVE
#}
#@onready var crew_list: Array[Unit] = [$Driver, $Gunner, $Commander]
#@onready var _state_chart: StateChart = $"../StateChart"
# Modules
@onready var propulsion = $Tracks
@onready var secondary_propulsion = null
@onready var transport = $Transport
@onready var cargo = null
@onready var main_weapon = $Autocannon
@onready var secondary_weapons = null

#func _ready():
#	pass

#func embark_crew(unit):
#	if crew_list.size() <= MAX_CREW:
#		crew_list.push_back(unit)
#		unit.PROCESS_MODE_DISABLED
#		unit.global_position = global_position
#		unit.visible = false
#	crew_positions["driver"] = CrewStatus.EMPTY
#	crew_positions["gunner"] = CrewStatus.EMPTY
#	crew_positions["commander"] = CrewStatus.EMPTY
#	propulsion._state_chart.send_event("driver enabled")
#	main_weapon._state_chart.send_event("gunner enabled")
#
#func embark_driver(unit):
#	pass
#
#func disembark_crew():
#	for unit in crew_list:
#		unit.PROCESS_MODE_INHERIT
#		unit.global_position = global_position + Vector2(50, 50)
#		unit.visible = true
#	crew_list.clear()
#	propulsion._state_chart.send_event("driver disabled")
#	main_weapon._state_chart.send_event("gunner disabled")
#	_state_chart.send_event("commander inactivated")

#func disembark_driver():
#	crew.remove(driver)

#class Crew_Position:
#	var position_type: CrewPos
#	var filled: bool = true
#	var connected_module: Module
#
#	func set_type(type: CrewPos):
#		position_type = type
#
#
#	func add_module(module: Module):
#		connected_module = module

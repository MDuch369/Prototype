extends Control

var displayed_unit: Unit
@onready var _state_chart: StateChart = $"../StateChart"
@onready var unit_name = $PanelFull/Name
@onready var mental = $PanelFull/Mental
@onready var crew = $PanelFull/Crew
@onready var passangers = $PanelFull/Passangers
@onready var passangers_num = $PanelFull/Passangers/PassangerNumber
@onready var rank = $PanelFull/Rank
@onready var xp = $PanelFull/XP
@onready var xp_bar = $PanelFull/XP/xp
@onready var ammo_big = $PanelFull/AmmoTank
@onready var ammo_big_bar = $PanelFull/AmmoTank/ammo
#@onready var ammo_med_bar = 
#@onready var ammo_small_bar = 
@onready var fuel = $PanelFull/Fuel
@onready var fuel_bar = $PanelFull/Fuel/fuel
@onready var maint = $PanelFull/Maint
@onready var maint_bar = $PanelFull/Maint/maint
@onready var damage = $PanelFull/Damage


func _process(delta):
	if not displayed_unit == null:
		xp_bar.value =  displayed_unit.experience
		fuel_bar.value =  displayed_unit.propulsion.current_resources
		ammo_big_bar.value =  displayed_unit.main_weapon.current_resources
		maint_bar.value =  displayed_unit.maintenance
		if not displayed_unit.transport == null:
			passangers_num.text = (
					str(displayed_unit.transport.embarked_units.size())
					+ "/" + str(displayed_unit.transport.TRANSPORT_CAPACITY)
				)

func show_unit(unit):
	if not unit is Infantry: # TEMP CODE
#		var unit = unit.get_node("unit")
		displayed_unit = unit
		unit_name.text = unit.unit_name
		_state_chart.send_event("show crew")
		_state_chart.send_event("show mantal")
		_state_chart.send_event("show experience")
		_state_chart.send_event("show unit window")
#		icon.add_child(unit.icon)
#		icon.visible = true
		# REFACTOR
		if not unit.crew_list.is_empty() and not unit.crew_list[0] == null:
#			_state_chart.send_event("enable driver")
			_state_chart.send_event("show driver")
		if unit.crew_list.size() > 1 and not unit.crew_list[1] == null:
#			_state_chart.send_event("enable gunner")
			_state_chart.send_event("show gunner")
		if unit.crew_list.size() > 2 and not unit.crew_list[2] == null:
#			_state_chart.send_event("enable commander")
			_state_chart.send_event("show commander")
		if unit.crew_list.size() > 3 and not unit.crew_list[3] == null:
#			_state_chart.send_event("enable loader")
			_state_chart.send_event("show loader")
		_state_chart.send_event("show mental")
		mental.visible = true
		
		_state_chart.send_event("show rank")
		rank.visible = true
		_state_chart.send_event("show xp")
		xp.visible = true
		xp_bar.value = unit.experience
#		xp_bar.max_value = 100.0
		_state_chart.send_event("show passangers")
		passangers.visible = true
		passangers_num.text = (
				str(displayed_unit.transport.embarked_units.size())
				+ "/" + str(displayed_unit.transport.TRANSPORT_CAPACITY)
		)
		_state_chart.send_event("show ammo")
		ammo_big.visible = true
		ammo_big_bar.value = unit.main_weapon.current_resources
		ammo_big_bar.max_value = unit.main_weapon.max_resources
		_state_chart.send_event("show fuel")
		fuel.visible = true
		fuel_bar.value = unit.propulsion.current_resources
		fuel_bar.max_value = unit.propulsion.max_resources
		_state_chart.send_event("show maint")
		maint.visible = true
		maint_bar.value = unit.maintenance
#		maint_bar.max_value = 100.0
		_state_chart.send_event("show damage")
		damage.visible = true


func change_displayed_unit(unit):
	displayed_unit = unit


func _on_unit_window_hidden_state_entered():
	visible = false


func _on_unit_window_visible_state_entered():
	visible = true


func _on_crew_visible_state_entered():
	crew.visible = true


func _on_driver_active_state_entered():
	crew.get_node("Driver").visible = true
	crew.get_node("DriverRed").visible = false


func _on_driver_inactive_state_entered():
	crew.get_node("Driver").visible = false
	crew.get_node("DriverRed").visible = true


func _on_gunner_active_state_entered():
	crew.get_node("Gunner").visible = true
	crew.get_node("GunnerRed").visible = false


func _on_gunner_inactive_state_entered():
	crew.get_node("Gunner").visible = false
	crew.get_node("GunnerRed").visible = true


func _on_commander_active_state_entered():
	crew.get_node("Commander").visible = true
	crew.get_node("CommanderRed").visible = false


func _on_commander_inactive_state_entered():
	crew.get_node("Commander").visible = false
	crew.get_node("CommanderRed").visible = true


func _on_mental_visible_state_entered():
	mental.visible = true


func _on_mental_not_visible_state_entered():
	mental.visible = false


func _on_rank_visible_state_entered():
	rank.visible = true


func _on_rank_not_visible_state_entered():
	rank.visible = false

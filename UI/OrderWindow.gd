extends Control

@onready var ui = $".."
#@onready var world = $"../world"
#@onready var units = $"../units"
#@onready var tac_unit = $"../tac_unit"
#@onready var _state_chart = $"../_state_chart"

#func _ready():
#	var world = ui.world

func _on_join_units_pressed():
	if not ui.world.selected_units.is_empty():
		var t_u = ui.tac_unit.instantiate()
		ui.units.add_child(t_u)


func _on_separate_units_pressed():
	if not ui.world.selected_units.is_empty():
		for unit in ui.world.selected_tac_units:
			unit.queue_free()


# TODO refactor
func _on_disembark_pressed():
	for unit in ui.world.selected_units:
		if not unit.modules.transport == null:
			unit.modules.transport.disembark()


func _on_disembark_crew_pressed():
	for unit in ui.world.selected_units:
		if not unit.crew_list.is_empty():
			unit.disembark_crew()
		ui._state_chart.send_event("hide mental")
		ui._state_chart.send_event("hide rank")


func _on_order_window_hidden_state_entered():
	pass # Replace with function body.


func _on_order_window_visibile_state_entered():
	pass # Replace with function body.


func _on_disembark_hidden_state_entered():
	pass # Replace with function body.


func _on_disembark_visibile_state_entered():
	pass # Replace with function body.


func _on_join_units_hidden_state_entered():
	pass # Replace with function body.


func _on_join_units_visible_state_entered():
	pass # Replace with function body.


func _on_seperate_units_visibile_state_entered():
	pass # Replace with function body.


func _on_seperate_units_hidden_state_entered():
	pass # Replace with function body.

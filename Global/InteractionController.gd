extends Node

#var unit_list = []
#var selected_units = []
#var higlighted_unit
##var enemy = false
#var enemy_selected = false
#var select_cursor = load("res://assets/custom/cursor_select.png")
#var attack_cursor = load("res://assets/custom/cursor_attack.png")
#
#func on_entered(unit):
#	higlighted_unit = unit
#	if is_enemy(unit) == true:
#		if is_selected() == true:
#			set_attack_cursor()
#	else:
#		set_select_cursor()
#	
#func on_exited():
#	higlighted_unit = null
#	Input.set_custom_mouse_cursor(null ,Input.CURSOR_ARROW)
#	
#func on_input_event(event):
#	if event is InputEventMouseButton:
#		if event.is_action_pressed("RightClick"): 
#			if selected_units.is_empty() == false:
#				if is_enemy(higlighted_unit) == true:
#					for unit in selected_units:
#						unit.get_node("Weapons").get_node("Cannon").attack(higlighted_unit)
#		if event.is_action_pressed("LeftClick"): 
#			higlighted_unit.set_selected(true)
#			selected_units.push_back(higlighted_unit)
#
#func is_enemy(unit):
#	for group in unit.get_groups():
#		if group.match("enemy"):
#			return true
#	return false
#
#func is_selected():
#	return !(selected_units.is_empty())
#func set_select_cursor():
#	Input.set_custom_mouse_cursor(select_cursor)
#func set_attack_cursor():
#	Input.set_custom_mouse_cursor(attack_cursor)

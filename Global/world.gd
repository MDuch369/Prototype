extends Node2D

signal selected_unit(unit)
signal unit_list_empty()
var mouse_ui := false
var mousePosition = Vector2()
var mousePositionGlobal = Vector2()
var start = Vector2()
var end = Vector2()
var startv = Vector2()
var endv = Vector2()
var isDragging := false
var selected_units: Array[Unit] = []
var selected_tac_units: Array[TacticalUnit]= []
var highlighted_unit: Unit
var order = load("res://units/order.tscn")
var select_cursor = load("res://assets/custom/cursors/cursor_select.png")
var attack_cursor = load("res://assets/custom/cursors/cursor_attack.png")
var attack_move_cursor = load("res://assets/custom/cursors/cursor_attack_move.png")
var movement_cursor = load("res://assets/custom/cursors/cursor_movement.png")
var resupply_cursor = load("res://assets/custom/cursors/cursor_resupply.png")
var embark_cursor = load("res://assets/custom/cursors/cursor_embark.png")
#var movement_target = load("res://assets/custom/movement_target.png")
var isRotating
var pos
@onready var _state_chart: StateChart = $StateChart
@onready var direction_cursor = $DirectionCursor
@onready var camera = $Camera
@onready var box = get_node("UI/SelectionBox")

#var direction_cursor = load("res://assets/custom/cursor_direction.png")

#func _ready():
#	selected_unit.connect(Callable(get_node("UI"), "_on_world_selected_unit"))
#	unit_list_empty()
#	get_units()
#	#Game.spawn_unit()


func _process(delta):
	if not mouse_ui:
		if Input.is_action_just_pressed("LeftClick"):
			start = mousePositionGlobal
			startv = mousePosition
			isDragging = true
		if isDragging:
			end = mousePositionGlobal
			endv = mousePosition
			draw_area()
		if Input.is_action_just_released("LeftClick"):
			#if startv.distance_to(mousePosition) > 20:
				for unit in selected_units:
					unit.set_selected(false)
				for tac_unit in selected_tac_units:
					if is_instance_valid(tac_unit):
						tac_unit.set_selected(false)
				selected_units.clear()
				selected_tac_units.clear()
				end = mousePositionGlobal
				endv = mousePosition
				isDragging = false
				draw_area(false)
				_on_area_selected()
			#else:
			#	end = start
			#	isDragging = false
			#	draw_area(false)
		if Input.is_action_just_pressed("RightClick"):
			start = mousePositionGlobal
			isRotating = true
		if isRotating:
			end = mousePositionGlobal
			if not selected_units.is_empty() and start.distance_to(end) > 10:
				draw_direction_cursor(start, end)
				queue_redraw()
		if Input.is_action_just_released("RightClick"):
			isRotating = false
			direction_cursor.visible = false


func _input(event):
	if not mouse_ui:
		if event is InputEventMouse:
			mousePosition = event.position
			mousePositionGlobal = get_global_mouse_position()
			if not selected_units.is_empty():
				#set_movement_cursor()
				if event.is_action_pressed("RightClick"): 
					pos = get_global_mouse_position()
				if event.is_action_released("RightClick"):
					for unit in selected_units:
						var orders = unit.get_node("Orders")
						if not highlighted_unit == null:
							if highlighted_unit.is_in_group("enemy") == true and highlighted_unit.active == true:
								#if selected_units.size() > 1:
								check_shift(event, unit)
								orders.create_order(unit, "attack", highlighted_unit)
#							elif higlighted_unit.is_in_group("friendly") and needs_supplies(higlighted_unit) == true:
#								#if selected_units.size() > 1:
#								check_shift(event, unit)
#								orders.create_order(unit, "supply", higlighted_unit)
#								#var supplier = unit.get_node("Modules").get_node("Cargo")
							if highlighted_unit.is_in_group("transport") and unit.is_in_group("transportable"):
								orders.create_order(unit, "embark", highlighted_unit)
#								highlighted_unit.get_node("Modules").transport.embark(unit)
							elif unit.is_in_group("crew"):
								orders.create_order(unit, "embark crew", highlighted_unit)
#								highlighted_unit.embark_crew(unit)
						else:
#							if unit is TacticalUnit:
#								unit.move_formation(mousePositionGlobal)
#							else:
							if selected_units.size() > 1:
								check_shift(event, unit)
								multiple_unit_move(selected_units, pos, mousePositionGlobal)
								#unit.follow_cursor = true
								break
							else:
								check_shift(event, unit)
								orders.create_order(unit, "move", pos)
								orders.create_order(unit, "rotate", mousePositionGlobal)
				#if event.is_action_released("RightClick"):
			#	for unit in selected_units:
			#		unit.follow_cursor = false
		#elif event.is_action_pressed("Rotate"):
		#	for unit in selected_units:
		#		clear_orders(unit)
		#		create_order(unit, "rotate", mousePositionGlobal)
		elif event.is_action_pressed("Stop"):
			for unit in selected_units:
				clear_orders(unit)
		elif event.is_action_pressed("FasterTime"):
			if Engine.time_scale < 2048:
				Engine.time_scale *= 2
				print(Engine.time_scale)
		elif event.is_action_pressed("SlowerTime"):
			if Engine.time_scale > 1:
				Engine.time_scale /= 2
		#elif event.is_action_pressed("Pause"):
		#	get_tree().paused = !get_tree().paused


func check_shift(event, unit):
	if not event.shift_pressed:
		clear_orders(unit)


func multiple_unit_move(unit_list, target, direction):
	var separation = 250.0
	var units = unit_list.duplicate(true)
	var targets =[]
	var dist = []
	for u in units:
		dist.push_back(u.global_position.distance_to(target))
	var centr_i = dist.find(dist.min())
	var centr_unit = unit_list[centr_i]
	var target_vector = target - centr_unit.global_position
	#var angle = target_vector.angle()
	var direction_vector = direction - target
	var angle = direction_vector.angle()#_to(target_vector)
	var perpendicular = direction_vector.orthogonal() + target
	#var perpendicular = target_vector.orthogonal() + target
	var n = 1
	var orders = centr_unit.get_node("Orders")
	orders.create_order(centr_unit, "move", target)
	orders.create_order(centr_unit, "rotate", Vector2.from_angle(angle) * 100 + target)
	units.pop_at(centr_i)
	while n <= units.size():
		var unit_target
		var perp = perpendicular.normalized() * 10000
		if n % 2 == 0:
			unit_target = target.move_toward(perp, separation * -n/2)
		else:
			unit_target = target.move_toward(perp, separation * ceil(n/2.0))
		targets.push_back(unit_target)
		n += 1
		#print(unit_target)
	while (not units.is_empty()) and (not targets.is_empty()):
		var distances = []
		for u in units:
			for t in targets:
				distances.push_back(u.global_position.distance_to(t))
		var d = distances.min()
		var i_d = distances.find(d)
		var u_d = units[ceil(i_d / units.size())]
		var t_d = targets[i_d % targets.size()]
		orders = u_d.get_node("Orders")
		orders.create_order(u_d, "move", t_d)
		orders.create_order(u_d, "rotate", Vector2.from_angle(angle) * 100 + t_d)
		units.erase(u_d)
		targets.erase(t_d)
#	print(selected_units)


func clear_orders(unit):
	if unit is CharacterBody2D:
		var orders = unit.get_node("Orders")
		orders.clear()



func draw_area(s = true):
	box.size = Vector2(abs(startv.x - endv.x), abs(startv.y - endv.y))
	var area_pos = Vector2()
	area_pos.x = min(startv.x, endv.x)
	area_pos.y = min(startv.y, endv.y)
	box.position = area_pos
	box.size *= int(s)


func _on_area_selected():
	var highlighted = []
	var select_rect = RectangleShape2D.new()
	var size = abs(end - start)
	select_rect.set_size(size)
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(select_rect)
	query.transform = Transform2D(0, (end + start) / 2)
	highlighted = space.intersect_shape(query)
	for unit in highlighted:
		var u = unit.collider
		if u.parent_unit == null:
			u.set_selected(true)
		else:
			u.parent_unit.set_selected(true)
			#selected_units.clear()
		if not u.is_in_group("tactical units"):
			selected_units.push_back(u)
		else:
			selected_tac_units.push_back(u)
	if not selected_units.is_empty():
		selected_unit.emit(selected_units[0])
	else:
		unit_list_empty.emit()
		


func on_entered(unit):
	highlighted_unit = unit
#	print(higlighted_unit)
	
	if is_selected() == true:
		for u in selected_units:
			if u.is_in_group("combat"):
				if unit.is_in_group("enemy") == true and highlighted_unit.active == true:
					if is_in_range(u) == false:
						set_attack_move_cursor()
						break
					else:
#						_state_chart.send_event("mouse entered enemy")
						set_attack_cursor()
				else:
					set_select_cursor()
			elif u.is_in_group("supplier") and needs_supplies(highlighted_unit) == true:
				set_resupply_cursor()
				#elif u.name == "Truck":
				#	if unit.
			if u.is_in_group("transportable") and highlighted_unit.is_in_group("transport"):
				set_embark_cursor()
	else:
		set_select_cursor()


#func on_entered(unit):
#	highlighted_unit = unit
#	print(higlighted_unit)
#
#	if is_selected() == true:
#		for u in selected_units:
#			if u.is_in_group("combat"):
#				if unit.is_in_group("enemy") == true and highlighted_unit.active == true:
#					if is_in_range(u) == false:
#						set_attack_move_cursor()
#						break
#					else:
#						set_attack_cursor()
#				else:
#					set_select_cursor()
#			elif u.is_in_group("supplier") and needs_supplies(highlighted_unit) == true:
#				set_resupply_cursor()
#				#elif u.name == "Truck":
#				#	if unit.
#			if u.is_in_group("transportable") and highlighted_unit.is_in_group("transport"):
#				set_embark_cursor()
#	else:
#		set_select_cursor()


func on_exited():
	highlighted_unit = null
	Input.set_custom_mouse_cursor(null ,Input.CURSOR_ARROW)


func on_ui_entered():
	mouse_ui = true


func on_ui_exited():
	mouse_ui = false


func is_in_range(unit):
	var weapon = unit.main_weapon
	var distance = unit.position.distance_to(highlighted_unit.position)
	if weapon.weapon_range < distance:
		return false
	return true


func needs_supplies(unit):
	for resource in unit.get_node("Modules").get_children():
		if resource.supply_request() == true:
			return true
	return false


func is_selected():
	return not selected_units.is_empty()


func set_select_cursor():
	Input.set_custom_mouse_cursor(select_cursor)


func set_attack_cursor():
	Input.set_custom_mouse_cursor(attack_cursor)


func set_attack_move_cursor():
	Input.set_custom_mouse_cursor(attack_move_cursor)


func set_movement_cursor():
	Input.set_custom_mouse_cursor(movement_cursor)


func set_resupply_cursor():
	Input.set_custom_mouse_cursor(resupply_cursor)


func set_embark_cursor():
	Input.set_custom_mouse_cursor(embark_cursor)


func draw_direction_cursor(dir_pos, tar):
	direction_cursor.visible = true
	direction_cursor.position = dir_pos
	var target = tar - dir_pos
	direction_cursor.rotation = target.angle()


func _on_resource_timer_timeout():
	Game.deployment_points += 100
	Game.supplies += 100


func _on_supply_cursor_state_entered():
	set_resupply_cursor()


func _on_embark_cursor_state_entered():
	set_embark_cursor()


func _on_attack_cursor_state_entered():
	set_attack_cursor()


func _on_select_cursor_state_entered():
	set_select_cursor()


func _on_default_cursor_state_entered():
	pass # Replace with function body.


func _on_move_attack_cursor_state_entered():
	set_attack_move_cursor()


#func attack_order(u, t):
#	var unit = u
#	var range = unit.get_node("Modules").get_node("Cannon").weapon_range
#	var target = t
#	var target_distance = unit.position.distance_to(target.position)
#	var new_target
#	var orders = unit.get_node("Orders")
#	if target_distance > range:
#		new_target = unit.position.move_toward(target.position, target_distance - range)
#		orders.create_order(unit, "move", new_target)
#		orders.create_order(unit, "attack", target)
#	else:
#		orders.create_order(unit, "attack", target)

#func supply_order(u, t):
#	var unit = u
#	var range = unit.get_node("Modules").get_node("Cargo").range
#	var target = t
#	var target_distance = unit.position.distance_to(target.position)
#	var new_target
#	var orders = unit.get_node("Orders")
#	if target_distance > range:
#		new_target = unit.position.move_toward(target.position, target_distance - range)
#		orders.create_order(unit, "move", new_target)
#		orders.create_order(unit, "supply", target)
#	else:
#		orders.create_order(unit, "supply", target)

#func create_order(unit, type, target):
#	if unit is CharacterBody2D:
#		var ord = order.instantiate()
#		ord.unit = unit
#		ord.type = type
#		if type == "move":
#			ord.global_position = target
#		elif type == "attack":
#			ord.global_position = target.global_position
#			ord.target_unit = target
#		elif type == "supply":
#			ord.global_position = target.global_position
#			ord.target_unit = target
#		elif type == "rotate":
#			ord.global_position = target
#		add_child(ord)
#		unit.orders.push_back(ord)
#		unit.set_order()

#func is_group(unit, group_name):
#	for group in unit.get_groups():
#		if group.match(group_name):
#			return true
#	return false

#func set_direction_cursor():
#	Input.set_custom_mouse_cursor(direction_cursor)


func on_units_selected():
	for unit in selected_units:
		if not unit.is_in_group("static"):
			_state_chart.send_event("mobile selected")
		if unit.is_in_group("combat"):
			_state_chart.send_event("combatant selected")
		if unit.is_in_group("infantry"):
			_state_chart.send_event("transportable selected")
		if unit.is_in_group("supplier"):
			_state_chart.send_event("supplier selected")


func highlighted_unit_type(unit):
#	if not unit.selected:
#		_state_chart.send_event("mouse entered not selected")
	if unit.is_in_group("enemy"):
		_state_chart.send_event("mouse entered enemy")
	elif unit.is_in_group("transport"):
		_state_chart.send_event("mouse entered embarkable")
	elif needs_supplies(unit):
		_state_chart.send_event("mouse entered resuppliable")


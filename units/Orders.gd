extends Node

var order_array: Array[Order] = []
var order = load("res://units/order.tscn")
@onready var unit = $".."
#@onready var modules = $"../Modules"
#@onready var _state_chart: StateChart = $"../StateChart"

#func _ready():
#	order = load("res://order.tscn")

func create_order(ordered_unit, type, target):
#	var ord
	var ord = order.instantiate()
	if type == "move":
		ord.type = ord.Type.MOVE
		ord.color = Color.GREEN
		ord.global_position = target
	elif type == "rotate":
		ord.type = ord.Type.ROTATE
		ord.color = Color.BLUE
		ord.global_position = target
	elif type == "attack":
		ord.type = ord.Type.ATTACK
		ord.color = Color.RED
		ord.global_position = target.global_position
		ord.target_unit = target
	elif type == "embark":
		ord.type = ord.Type.EMBARK
		ord.color = Color.PURPLE
		ord.global_position = target.global_position
		ord.target_unit = target
	elif type == "supply":
		ord.type = ord.Type.SUPPLY
		ord.color = Color.YELLOW
		ord.global_position = target.global_position
		ord.target_unit = target
	add_child(ord)
	if order_array.is_empty():
		ord.start_pos = ordered_unit.global_position - ord.global_position
	else:
		ord.start_pos = order_array.back().global_position - ord.global_position
	order_array.push_back(ord)
	if order_array.size() == 1:
		set_order()

func set_order():
	if not order_array.is_empty():
		var propulsion = unit.propulsion
		var weapon = unit.main_weapon
		var cargo = unit.cargo
		# refactor
#		var propulsion
#		var weapon
#		var cargo
#		if not modules.propulsion == null:
#			propulsion = modules.propulsion
#		if not modules.main_weapon == null:
#			weapon = modules.main_weapon
#		if not modules.cargo == null:
#			cargo = modules.cargo
		# /refactor 
		var set_ord = order_array[0]
		if set_ord.type == set_ord.Type.MOVE:
			unit._state_chart.send_event("move")
			propulsion.active_order = set_ord
			propulsion.target = set_ord.global_position
#			propulsion.status = "moving"
			#propulsion.set_movement_target(order.position)
		elif set_ord.type == set_ord.Type.ROTATE:
			unit._state_chart.send_event("rotate")
			propulsion.active_order = set_ord
			propulsion.target = set_ord.global_position
#			propulsion.status = "rotating"
		elif set_ord.type == set_ord.Type.ATTACK:
			unit._state_chart.send_event("shoot")
			weapon.active_order = set_ord
			weapon.target = set_ord.target_unit
			weapon.engage_target()
		elif set_ord.type == set_ord.Type.EMBARK:
			unit._state_chart.send_event("move")
			propulsion.active_order = set_ord
			propulsion.target = set_ord.target_unit.global_position
		elif set_ord.type == set_ord.Type.SUPPLY:
#			cargo._state_chart.send_event("supply")
			cargo.active_order = set_ord
			cargo.current_target = set_ord.target_unit

func update_order():
	var ord = order_array[0]
#	if is_instance_valid(ord):
	ord.start_pos = unit.global_position - ord.global_position

func _process(delta):
	if not order_array.is_empty():
		update_order()

func clear():
	while not order_array.is_empty():
		order_array[0].clear()
	order_array.clear()
#	for ord in order_array:
#		ord.clear()

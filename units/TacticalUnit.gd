class_name TacticalUnit
extends Unit

enum Formation {
	COLUMN,
	LINE,
	WEDGE,
	ECHELON,
} 
var unit_list: Array[Unit] = []
var type # tank, infantry, trucks etc. 
var tier # fireteam, squad, platoon, company, battalion, regiment, brigade
#var spacing: float
var spacing := 50.0
var positions: Array[Vector2] = []
#@onready var parent = $".."


func _ready():
	super()
	add_to_group("tactical units", true)
	add_units()
	set_own_position()
	set_positions()


func _physics_process(delta):
	set_own_position()
#	var pos = Vector2.ZERO
#	for unit in unit_list:
#		pos += unit.global_position
#	global_position = pos / unit_list.size()


func add_units():
	for unit in world.selected_units:
		unit_list.push_back(unit)
		unit.set_parent_unit(self)

func set_own_position():
	var pos = Vector2.ZERO
	for unit in unit_list:
		pos += unit.global_position
	global_position = pos / unit_list.size()


func set_positions():
	var center = global_position
	var n = 0
	for unit in unit_list:
		var ord = unit.get_node("Orders")
		var unit_rot = n * (( 2 * PI )  / unit_list.size() )
		var unit_pos = center + ( Vector2.from_angle(unit_rot) * spacing )
		ord.create_order(unit, "move", unit_pos)
		n += 1

func move_formation(target):
	var center = target.global_position
	var n = 0
	for unit in unit_list:
		var ord = unit.get_node("Orders")
		var unit_rot = n * (( 2 * PI )  / unit_list.size() )
		var unit_pos = center + ( Vector2.from_angle(unit_rot) * spacing )
		ord.create_order(unit, "move", unit_pos)
		n += 1



func set_selected(value):
	selected = value
	box.visible = value
	for unit in unit_list:
		unit.set_selected(value)
		world.selected_units.push_back(unit)


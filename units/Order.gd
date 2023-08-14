class_name Order
extends Node2D

enum Type {
	MOVE,
	ROTATE,
	ATTACK,
	SUPPLY,
	EMBARK,
	EMBARK_CREW,
}
var type 
var target_unit
@onready var unit = $"../.."
@onready var orders = $".."
var start_pos = Vector2.ZERO
var color

func _draw():
	draw_dashed_line(start_pos, Vector2.ZERO, color, 3.0, 20.0)

func _process(delta):
	queue_redraw()

func clear():
	orders.order_array.pop_at(0)
	queue_free()
	#orders.set_order()
	#orders.clear_order()
	#if unit.orders.size() > 0: 
	#	if unit.orders[0] == self:

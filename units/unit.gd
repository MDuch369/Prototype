class_name Unit
extends PhysicsBody2D

signal _mouse_entered(unit)
@export var id: String
@export var selected := false
var parent_unit: Unit = null
var order_list = []
var icon
var unit_name: String
@onready var box = $"Box"
@onready var world = $"../.."
@onready var units = $".."
#var orders = []


func _ready():
	_mouse_entered.connect(Callable(world, "on_entered"))
	mouse_exited.connect(Callable(world, "on_exited"))
	set_pickable(true)
	set_selected(selected)
	add_to_group("units", true)


func _mouse_enter():
	_mouse_entered.emit(self)


func _mouse_exit():
	mouse_exited.emit()


func set_selected(value):
	selected = value
	box.visible = value


func set_parent_unit(par):
	parent_unit = par


func remove_parent_unit():
	parent_unit = null

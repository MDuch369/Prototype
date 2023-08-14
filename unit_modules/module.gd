class_name Module
extends Node2D


enum Damage {
	NONE,
	LIGHT,
	MEDIUM,
	SEVERE,
	CRITICAL,
	DESTROYED,
}
var crewed: bool
var required_crew: int
var active_order
var status: String = "idle"
var type: String
var order = load("res://units/order.tscn")
@onready var orders = $"../../Orders"
@onready var unit: Unit = $"../.."
#var crewed: bool
#var damage = 0

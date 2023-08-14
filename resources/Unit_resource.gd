extends Node

@export var type = ""
@export var max_capacity = 500
@export var current_capacity = 0
@onready var weapon = $"../Cannon"
var supply_receiver
var supply_provider
var on_full_capacity
var on_zero_capacity
signal full_capacity
signal zero_capacity

#func _ready():
#	if weapon != null:
#		max_capacity = weapon.reserve_ammo
	#current_capacity = max_capacity

func supply_request():
	if current_capacity < max_capacity:
		return true
	else:
		return false
		
func add_supplier(sup):
	supply_provider = sup
	on_full_capacity = Callable(supply_provider, "finish_transfer")
	full_capacity.connect(on_full_capacity)

func add_receiver(rec):
	supply_receiver = rec
	on_zero_capacity = Callable(supply_receiver, "finish_transfer")
	zero_capacity.connect(on_zero_capacity)

#func remove_supplier():
#	supply_provider = null
#	if full_capacity.is_connected(on_full_capacity):
#		full_capacity.disconnect(on_full_capacity)

func supplies_transfered(amount):
	current_capacity -= amount
	print(current_capacity)
	if current_capacity <= 0:
		current_capacity = 0
		zero_capacity.emit()
#		remove_receiver()
		
func transfer_received(amount):
	current_capacity += amount
	if current_capacity >= max_capacity:
		current_capacity = max_capacity
		full_capacity.emit()
#		remove_supplier()

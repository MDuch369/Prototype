class_name ModuleResource
extends Module

signal full_capacity
signal zero_capacity
var supply_receiver
var supply_provider
var on_full_capacity
var on_zero_capacity
var resource: String
var max_resources: float
var current_resources: float
var resource_transfer_cost: float
var resource_usage: float


func supply_request():
	if current_resources < max_resources:
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


func transfer_received(amount):
	current_resources += amount / resource_transfer_cost
	if current_resources >= max_resources:
		current_resources = max_resources
		full_capacity.emit()

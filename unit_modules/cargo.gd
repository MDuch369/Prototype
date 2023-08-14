extends Node2D

# Module
var type = "cargo"
var resource = "supplies"
var damage = 0
var crewed = true
var active_order = null

# Resources
@export var max_resources = 2500
@export var current_resources = 2000
@export var resource_transfer_cost = 1
var supply_receiver
var supply_provider
var on_full_capacity
var on_zero_capacity
signal full_capacity
signal zero_capacity
signal receiver_left

# Supply transfer
@export var range = 300
var current_target = null
#var closing = false
var units_in_range = []
@onready var supply_transfer = preload("res://resources/supply_transfer.tscn")
@onready var transfer_list = $TransferList
@onready var supplyRangeVisualisation = $SupplyRange
@onready var supply_area = $SupplyArea/CollisionShape2D.shape
@onready var unit = $"../.."

func _ready():
	supplyRangeVisualisation.visible = false
	supply_area.radius = range
	# THIS IS A HORRIBLE HACK, TO BE REPLACED BY SOMETHING SENSIBLE
	supplyRangeVisualisation.size = Vector2(range * 2, range * 2)
	supplyRangeVisualisation.position = Vector2(-range, -range)

func _input(event):
	if event.is_action_pressed("SupplyRangeViualisation"):
		supplyRangeVisualisation.visible = !supplyRangeVisualisation.visible

func _physics_process(delta):
	if active_order != null and active_order.type == "supply":
		var modules = current_target.get_node("Modules").get_children()
		for module in modules:
			var type =  module.resource
			var receiver = module
			#print(receiver)
			if module.supply_request() == true:
				if exists_transfer(type, receiver) != true: 
					create_transfer(type, receiver)
				
func clear_target(modules):
	var clear = true
	for module in modules:
		if module.supply_request() == true:
			clear = false
			break
	current_target = null

func exists_transfer(type, receiver):
	if transfer_list.get_child_count() > 0:
		for transfer in transfer_list.get_children():
			if transfer.supply_type == type and transfer.supply_receiver == receiver:
				return true
			else:
				return false
	else:
		return false

func supply(target):
	if current_resources >= 1:
		current_target = target
		#var target_distance = unit.position.distance_to(target.position)
		#if target_distance > range:
		#	closing = true
		#	var new_target = unit.position.move_toward(target.position, target_distance - range)
		#	unit.closing = true
		#	unit.target = new_target
		#else:
		#	var modules = target.get_node("Modules").get_children()
		#	for module in modules:
		#		var type =  module.resource
		#		var receiver = module
		#		var transfer = create_transfer(type, receiver)
				#transfer.start_supplying()

func supply_request():
	if current_resources < max_resources:
		return true
	else:
		return false

func create_transfer(type, receiving_module):
	#print("CREATED")
	var transfer = supply_transfer.instantiate()
	#var path = get_tree().get_root().get_node("World")
	#path.
	transfer_list.add_child(transfer)
	transfer.set_type(receiving_module.resource)
	#var provider = self.get_parent().get_node("Modules").get_node("Supplies")
	transfer.add_provider(self)
	transfer.add_receiver(receiving_module)
	transfer.start_supplying()
	#return transfer

func _on_supply_area_body_entered(body):
	var parent = self.get_parent().get_parent()
	if parent != body:
		if body.has_node("Modules"):
			for resource in body.get_node("Modules").get_children():
				if resource.supply_request() == true:
					units_in_range.push_back(body)
					break
					#var transfer = create_transfer(resource.type, resource)
					#body.active_transfers.push_back(transfer)
					#receiver_left.connect(Callable(transfer, "finish_transfer"))
					#transfer.start_supplying()

func _on_supply_area_body_exited(body):
	var unit = units_in_range.find(body)
	if unit != -1:
		units_in_range.remove_at(unit)
		#print(units_in_range)
	#if body.has_node("Modules"):
	#	if body.active_transfers.is_empty() == false:
	#		for transfer in body.active_transfers:
	#			for resource in self.get_parent().get_node("Resources").get_children(): 
	#				if transfer.supply_provider == resource:
	#					transfer.finish_transfer()
		receiver_left.emit()

func add_supplier(sup):
	supply_provider = sup
	on_full_capacity = Callable(supply_provider, "finish_transfer")
	full_capacity.connect(on_full_capacity)
func add_receiver(rec):
	supply_receiver = rec
	on_zero_capacity = Callable(supply_receiver, "finish_transfer")
	zero_capacity.connect(on_zero_capacity)
func supplies_transfered(amount):
	current_resources -= amount
	#print(current_resources)
	if current_resources <= 0:
		current_resources = 0
		zero_capacity.emit()
func transfer_received(amount):
	current_resources += amount
	if current_resources >= max_resources:
		current_resources = max_resources
		full_capacity.emit()

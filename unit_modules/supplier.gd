extends Node2D

@onready var supply_transfer = preload("res://resources/supply_transfer.tscn")
@onready var supplyRangeVisualisation = $SupplyRange
signal receiver_left
var supplyReceiver
var units_in_range = []
#var suply_speed = 20
#var supplying = false
 
func _ready():
	supplyRangeVisualisation.visible = false

func _input(event):
	if event.is_action_pressed("Alt"):
		supplyRangeVisualisation.visible = !supplyRangeVisualisation.visible

func create_transfer(type, resource):
	var transfer = supply_transfer.instantiate()
	var path = get_tree().get_root().get_node("World")
	path.add_child(transfer)
	transfer.set_type(resource.type)
	var provider = self.get_parent().get_node("Modules").get_node("Supplies")
	transfer.add_provider(provider)
	transfer.add_receiver(resource)
	return transfer

func _on_supply_area_body_entered(body):
	var parent = self.get_parent()
	if parent != body:
		if body.has_node("Modules"):
			for resource in body.get_node("Modules").get_children():
				if resource.supply_request() == true:
					units_in_range.push_back(body)
					print(units_in_range)
					break
					#var transfer = create_transfer(resource.type, resource)
					#body.active_transfers.push_back(transfer)
					#receiver_left.connect(Callable(transfer, "finish_transfer"))
					#transfer.start_supplying()

# 
func _on_supply_area_body_exited(body):
	var unit = units_in_range.find(body)
	if unit != -1:
		units_in_range.remove_at(unit)
		print(units_in_range)
	#if body.has_node("Modules"):
	#	if body.active_transfers.is_empty() == false:
	#		for transfer in body.active_transfers:
	#			for resource in self.get_parent().get_node("Resources").get_children(): 
	#				if transfer.supply_provider == resource:
	#					transfer.finish_transfer()
		receiver_left.emit()

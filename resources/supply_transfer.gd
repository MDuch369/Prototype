extends Node

@onready var timer = $Timer
@onready var rec_ui
@onready var prov_ui
signal supply_given(amount)
signal supply_taken(amount)
var supply_provider
var supply_receiver
var supply_type
var supply_speed = 50
var supply_rate = 0.5

func _on_timer_timeout():
	if supply_provider.current_resources > 0:
		#if supply_receiver.current_amount < supply_receiver.max_capacity:
			supply_taken.emit(supply_speed)
			supply_given.emit(supply_speed)
	else:
		finish_transfer()
	
func set_type(type):
	supply_type = type

func add_provider(prov):
	supply_provider = prov
	supply_taken.connect(Callable(prov, "supplies_transfered"))
	#prov_ui = prov.get_parent().get_parent().get_node("UnitUI").get_node("Panel3")

func add_receiver(rec):
	supply_receiver = rec
	rec_ui = rec.get_parent().get_parent().get_node("TankUI").get_node("SupplyIn")
	supply_given.connect(Callable(rec, "transfer_received"))
	rec.add_supplier(self)

func start_supplying():
	timer.start()
	rec_ui.showing = true
	#prov_ui.showing = true
	
func finish_transfer():
	timer.stop()
	rec_ui.showing = false
	#prov_ui.showing = false
	queue_free()


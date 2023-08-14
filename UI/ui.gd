extends CanvasLayer

signal ui_entered
signal ui_exited
var tac_unit = load("res://units/tactical_unit.tscn")
var warehouse = load("res://objects/depot.tscn")
var tank = load("res://units/tank.tscn")
var truck = load("res://units/truck.tscn")
var soldier = load("res://units/soldier.tscn")
var apc = load("res://units/APC.tscn")
@onready var _state_chart: StateChart = $StateChart
@onready var deployment_label = $Resources/DeploymentLabel
@onready var supplies_label = $Resources/SuppliesLabels
@onready var unit_panel_full = $UnitWindow/PanelFull
@onready var unit_panel_folded = $UnitWindow/PanelFolded
@onready var timer = $Timer
@onready var pause = $PauseWindow
@onready var world = $".."
@onready var units = $"../Units"
@onready var objects = $"../Objects"
@onready var spawn = $"../UnitSpawn"
@onready var unit_window = $UnitWindow
@onready var order_window = $OrderWindow

func _ready():
	ui_entered.connect(Callable(world, "on_ui_entered"))
	ui_exited.connect(Callable(world, "on_ui_exited"))
	unit_panel_folded.visible = false


func _process(delta):
	deployment_label.text = "Deployment Points: " + str(Game.deployment_points) 
	supplies_label.text = "Supplies: " + str(Game.supplies)


func _input(event):
	if event.is_action_pressed("Pause"):
		pause.visible = !pause.visible
		get_tree().paused = !get_tree().paused


func connect_to_timer(object):
	timer.timeout.connect(Callable(object, "_on_timer_timeout"))


func _on_button_mouse_entered():
	ui_entered.emit()
#	print("entered")


func _on_button_mouse_exited():
	ui_exited.emit()
#	print("exited")


func _on_warehouse_pressed():
	if Game.deployment_points >= 1000:
		Game.deployment_points -= 1000
		var new_warehouse = warehouse.instantiate() 
		objects.add_child(new_warehouse)
		new_warehouse.set_build_mode()
		new_warehouse.global_position = world.get_global_mouse_position()


func _on_tank_pressed():
	if Game.deployment_points >= 100:
		Game.deployment_points -= 100
		var new_tank = tank.instantiate() 
		units.add_child(new_tank)
		new_tank.global_position = spawn.global_position


func _on_infantry_pressed():
	if Game.deployment_points >= 10:
		Game.deployment_points -= 10
		var new_soldier = soldier.instantiate() 
		units.add_child(new_soldier)
		new_soldier.global_position = spawn.global_position


func _on_truck_pressed():
	if Game.deployment_points >= 50:
		Game.deployment_points -= 50
		var new_truck = truck.instantiate() 
		units.add_child(new_truck)
		new_truck.global_position = spawn.global_position


func _on_apc_pressed():
	if Game.deployment_points >= 75:
		Game.deployment_points -= 75
		var new_apc = apc.instantiate() 
		units.add_child(new_apc)
		new_apc.global_position = spawn.global_position


func _on_unfold_pressed():
	unit_panel_full.visible = true
	unit_panel_folded.visible = false


func _on_fold_pressed():
	unit_panel_full.visible = false
	unit_panel_folded.visible = true


func _on_debug_time_speed_pressed():
	print(Engine.time_scale)


func _on_world_selected_unit(unit):
	unit_window.show_unit(unit)


func _on_world_unit_list_empty():
	_state_chart.send_event("hide unit window")

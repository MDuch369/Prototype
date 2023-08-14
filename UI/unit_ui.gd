extends Control

@onready var ammoBar = $ammo
@onready var fuelBar = $fuel
@onready var unit = $".."
@onready var ammo = $"../Modules/Cannon"
@onready var fuel = $"../Modules/Propulsion"
@onready var parent = $".."
#@onready var fuel = $"../Modules/Fuel"

func _ready():
	ammoBar.max_value = ammo.max_resources
	fuelBar.max_value = fuel.max_resources


func _process(delta):
	ammoBar.value = ammo.current_resources
	fuelBar.value = fuel.current_resources


# THIS IS A HORRIBLE HACK, BUT IT HAS TO DO FOR NOW
func _physics_process(delta):
	var unit_rotation = parent.global_rotation
	if unit_rotation != 0:
		rotation = -unit_rotation


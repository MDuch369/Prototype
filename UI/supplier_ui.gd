extends Control
@onready var supplyBar = $supplies
@onready var truck = $".."
@onready var supplies = $"../Modules/Cargo"
@onready var parent = $".."

func _ready():
	supplyBar.max_value = supplies.max_resources

func _process(delta):
	supplyBar.value = supplies.current_resources

func _physics_process(delta):
	var unit_rotation = parent.global_rotation
	if unit_rotation != 0:
		rotation = -unit_rotation

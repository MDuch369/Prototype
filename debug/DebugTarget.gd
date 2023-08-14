#extends StaticBody2D
extends BasicUnit


#var active = true
#@onready var world = $"../.."
@onready var smoke = $Smoke
#signal _mouse_entered(unit)

func _ready():
	super()
#	_mouse_entered.connect(Callable(world, "on_entered"))
#	mouse_exited.connect(Callable(world, "on_exited"))
#	set_pickable(true)
#	add_to_group("units", true)
	add_to_group("non combat", true)
	add_to_group("enemy", true)

#func _mouse_enter():
#	_mouse_entered.emit(self)
#func _mouse_exit():
#	mouse_exited.emit()

func destroyed():
	active = false
	#THIS IS A HACK
	await get_tree().create_timer(0.3).timeout
	smoke.visible = true

func hit(strength):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var result = rng.randi_range(1, 10) + strength
	if result > 10:
	#if result > 9:
		destroyed()

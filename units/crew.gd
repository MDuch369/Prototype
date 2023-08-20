extends Infantry

@onready var propulsion = $Modules/Legs
@onready var main_weapon = $Modules/Rifle
@onready var cargo = null
@onready var _state_chart = $StateChart

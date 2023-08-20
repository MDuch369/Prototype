extends Node2D


var driver = [propulsion]
var gunner = [primary_weapon, secondary_weapon]
var commander = [primary_weapon, secondary_weapon]
#@onready var crew_state_chart = $CrewStateChart
@onready var primary_weapon = $"../Modules/Autocannon"
@onready var secondary_weapon
@onready var propulsion = $"../Modules/Tracks"

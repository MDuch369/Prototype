class_name BasicUnit
extends Unit

enum mental_state {
	RELAXED,
	FOCUSED,
	NERVOUS,
	STRESSED,
	PANICKED,
	SUPPRESSED,
	KNOCKED_OUT,
}
var active := true
var follow_cursor := false
var rank: int
var experience: float
var maintenance: float
var stress: float
@onready var modules = $Modules

func add_experience(exp):
	experience += exp


func promote():
	rank += 1


func add_stress(str):
	stress += str


func remove_stress(str):
	stress -= str


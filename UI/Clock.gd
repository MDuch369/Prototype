extends Label

@onready var clock = $Clock
var seconds = 0
var minutes = 0
var hours = 0


func _ready():
	text = "00 : 00 : 00"


func _on_clock_timeout():
	seconds += 1
	if seconds % 60 == 0:
		minutes += 1
	if minutes % 60 == 0:
		hours += 1
	#	seconds = 0
	text = (
			str(seconds / 3600) + str((seconds / 3600) % 10) + " : "
			 + str(seconds / 600) + str((seconds / 60) % 10) + " : "
			 + str((seconds - minutes * 60) / 10) +  str(seconds % 10)
		)
#

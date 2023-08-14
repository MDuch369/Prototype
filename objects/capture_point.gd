extends Area2D

const CAPTURE_TIME := 30.0
enum Controler {
	NEUTRAL,
	BLUE,
	RED,
}
var capturing_units: Array[Unit]
var capturing_progress := 0
@onready var timer = $CaptureTimer
@onready var progress_bar_blue = $CaptureBarBlue
@onready var progress_bar_red = $CaptureBarRed
@onready var neutral_flag = $CaptureFlagNeutral
@onready var blue_flag = $CaptureFlagBlue
@onready var red_flag = $CaptureFlagRed


func _process(delta):
	if not capturing_units.is_empty():
		progress_bar_blue.value = capturing_progress
		progress_bar_red.value = capturing_progress

func start_capturing(team):
	timer.start(1)
	if team == "blue":
		progress_bar_blue.visible = true
	else:
		progress_bar_red.visible = true


func capture(team):
	Controler.BLUE
	progress_bar_blue.visible = false
	progress_bar_red.visible = false
	neutral_flag.visible = false
	if team == "blue":
		blue_flag.visible = true
		Controler.BLUE
	else:
		red_flag.visible = true
		Controler.RED


func _on_body_entered(body):
	var unit = body
	if unit.is_in_group("friendly"):
		start_capturing("blue")
		capturing_units.push_back(unit)


func _on_body_exited(body):
	var unit = body
	capturing_units.erase(unit)
	if capturing_units.is_empty():
		timer.stop()
		progress_bar_blue.visible = false
		progress_bar_red.visible = false


func _on_capture_timer_timeout():
	capturing_progress += 1
	if capturing_progress == CAPTURE_TIME:
		capture("blue")
	else:
		timer.start(1)

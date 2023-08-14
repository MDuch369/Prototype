extends Control

@onready var unfolded = $PanelFull
@onready var folded = $PanelFolded


func _on_fold_pressed():
	unfolded.visible = false
	folded.visible = true


func _on_unfold_pressed():
	unfolded.visible = true
	folded.visible = false

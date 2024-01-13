extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_entered(_body):
	var button = $Area2D.find_child("Ebutton")
	button.visible = true
	Global.atExit = true

func _on_player_exited(_body):
	var button = $Area2D.find_child("Ebutton")
	button.visible = false
	Global.atExit = false

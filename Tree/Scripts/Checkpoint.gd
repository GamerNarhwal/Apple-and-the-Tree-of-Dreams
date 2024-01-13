extends Node2D

var start = false
var activated = false

func _on_player_enter(_body):
	if not start:
		start = true
	else:
		if not activated:
			Global.currentCheckPoint = position
			activated = true
	

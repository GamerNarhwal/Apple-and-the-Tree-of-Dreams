extends Node2D

var start = false

func _on_player_enter(body):
	if not start:
		start = true
	else:
		body.position = Global.currentCheckPoint

extends Node2D

var original_jump_force
var original_gravity_scale = Global.gravity_scale

# Called when the node enters the scene tree for the first time.
func _ready():
	original_jump_force = Global.jump_force

func _on_water_body_entered(body):
		if body is Player:
			Global.jump_force = -500
			Global.gravity_scale = Global.gravity_scale * 0.25
			Global.is_in_water = true


func _on_water_body_exited(_body):
	Global.jump_force = original_jump_force
	Global.is_in_water = false
	Global.gravity_scale = original_gravity_scale


extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass



func _on_area_2d_body_entered(body):
	if body is Player :
		Global.jump_force = Global.jump_force / 2
		Input.action_press("ui_jump")
	if body is Player and body.is_on_floor() and Input.is_action_just_pressed("ui_jump"):
		Global.jump_force = -2000
		


func _on_area_2d_body_exited(_body):
	Global.jump_force = -1000
		


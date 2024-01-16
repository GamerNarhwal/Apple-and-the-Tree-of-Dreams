extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $Area2D.find_child("BestE").visible == true and Input.is_action_just_pressed("ui_key_e"):
		Global.isPaused = true
		self.find_child("ColorRect").visible = true
		Global.is_in_menu = true
	elif Input.is_action_just_pressed("ui_cancel"):
		Global.isPaused = false
		self.find_child("ColorRect").visible = false
		Global.is_in_menu = false

func _on_world_select_entered(body):
	if body is Player:
		var button = $Area2D.find_child("BestE")
		button.visible = true

func _on_world_select_exited(body):
	if body is Player:
		var button = $Area2D.find_child("BestE")
		button.visible = false

#Tree World Levels are 1-4
func on_tree_level_one_pressed():
	get_tree().change_scene_to_file(Global.level[1])
	Global.isPaused = false


func _on_tree_level_two_pressed():
	if Global.furthestLevel > 1:
		get_tree().change_scene_to_file(Global.level[2])
		Global.isPaused = false


func _on_tree_level_three_pressed():
	if Global.furthestLevel > 2:
		get_tree().change_scene_to_file(Global.level[3])
		Global.isPaused = false


func _on_tree_level_four_pressed():
	if Global.furthestLevel > 3:
		get_tree().change_scene_to_file(Global.level[4])
		Global.isPaused = false

extends Node


func _on_level_one_pressed():
	Global.current_level = 1
	get_tree().change_scene_to_file(Global.level[1])

func _on_level_1_2_pressed():
	if Global.furthestLevel > 1:
		Global.current_level = 2
		get_tree().change_scene_to_file(Global.level[2])

func _on_level_1_3_pressed():
	if Global.furthestLevel > 2:
		Global.current_level = 3
		get_tree().change_scene_to_file(Global.level[3])

func _on_level_1_4_pressed():
	if Global.furthestLevel > 3:
		Global.current_level = 4
		get_tree().change_scene_to_file(Global.level[4])

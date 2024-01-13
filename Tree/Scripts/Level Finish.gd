extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.atExit == true and Input.is_action_just_pressed("ui_key_e"):
		visible = true
		Global.isPaused = true
	elif Global.isPaused == false:
		visible = false

func _on_menu_exit_pressed():
	if Global.furthestLevel == Global.current_level:
		Global.furthestLevel += 1
	Global.current_level = 0
	visible = false
	Global.isPaused = false
	get_tree().change_scene_to_file(Global.level[0])
	

func _on_next_level_pressed():
	if Global.furthestLevel == Global.current_level:
		Global.furthestLevel += 1
	Global.current_level += 1
	print(Global.current_level)
	print(Global.furthestLevel)
	visible = false
	Global.isPaused = false
	get_tree().change_scene_to_file(Global.level[Global.current_level])

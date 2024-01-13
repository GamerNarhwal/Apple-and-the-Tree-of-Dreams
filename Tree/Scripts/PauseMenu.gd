extends CanvasLayer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
# Handles menu
	if Input.is_action_just_pressed("ui_cancel"):
		if visible:
			Global.isPaused = false
			visible = false
		else:
			Global.isPaused = true
			visible = true

		
func _on_resume_pressed():
	# Replace with function body.
	Global.isPaused = false
	visible = false


func _on_exit_pressed():
	get_tree().change_scene_to_file(Global.level[0])
	Global.isPaused = false

func _on_restart_pressed():
	get_tree().reload_current_scene()
	Global.isPaused = false
	Global.currentCheckPoint = Global.playerStartPosition


	
 


extends Sprite2D 


func _process(delta):
	if Input.is_action_pressed("ui_right"):
		position += Vector2.RIGHT * delta * 100
	elif Input.is_action_pressed("ui_left"):
		position += Vector2.LEFT * delta * 100

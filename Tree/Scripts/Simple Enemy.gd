extends CharacterBody2D

var speed = 400
var direction = Vector2(1, 0)
var gravity = 980

@onready var raycast_left = $RayCast2D_Left
@onready var raycast_right = $RayCast2D_Right

func _physics_process(delta):
	velocity = speed * direction
	velocity.y += gravity * delta

	var collision_info = move_and_slide()

	if direction.x == -1 and !raycast_left.is_colliding():
		direction.x *= -1
	elif direction.x == 1 and !raycast_right.is_colliding():
		direction.x *= -1

	if collision_info:
		direction.x *= -1

	if direction.x == 1:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

	# Inside _physics_process function after move_and_slide
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() is Player:  # Assuming 'Player' is the class name of your player
			collision.get_collider().position = Global.currentCheckPoint

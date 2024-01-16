extends CharacterBody2D

class_name Player

@onready var animations = $AnimationPlayer

const JUMP_VELOCITY = -1000.0 

signal direction_changed(new_direction)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var last_non_zero_direction = 1

func _enter_tree():
	Global.playerStartPosition = position
	Global.currentCheckPoint = Global.playerStartPosition
	position = Global.playerStartPosition

	
func updateAnimation():
	animations.play("move_right")

func _physics_process(delta):
	if not Global.isPaused:
		updateAnimation()
		
		# Add the gravity.
		if not is_on_floor():
			velocity.y += Global.gravity_scale * delta
			animations.pause()
			animations.seek(0)
		
		# Handle jump.
		if Input.is_action_just_pressed("ui_jump") and is_on_floor():
			velocity.y = Global.jump_force
		elif Input.is_action_just_pressed("ui_jump") and Global.is_in_water:
			velocity.y = Global.jump_force
			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * Global.run_speed
			last_non_zero_direction = direction
		else:
			# If the player isn't moving, don't update the velocity
			direction = 0
			animations.pause()
			animations.seek(0)

		# If the player is not in the wind area, gradually reduce their velocity until it reaches zero
		if !Global.isWindy:
			velocity.x = lerp(velocity.x, 0.0, 0.2)  # Adjust the third parameter as needed to control the rate of deceleration
		
		var sprite = $Sprite2D3  # Replace "Sprite2D" with the actual name of your Sprite2D node
		sprite.flip_h = last_non_zero_direction < 0
		Global.last_non_zero_direction = last_non_zero_direction

		move_and_slide()
		emit_signal("direction_changed", last_non_zero_direction)

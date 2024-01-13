extends Node2D

var push_back_velocity = Vector2(1000, 0) # Adjust this value as needed
var is_player_in_area = false
var ground_wind_speed = 300 # Adjust this value as needed
var air_wind_speed = 500 # Adjust this value as needed
var original_run_speed = Global.run_speed # Store the original run speed

# Add a variable for the wind direction. Set it to 1 for right and -1 for left.
var wind_direction = -1

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body is CharacterBody2D:
		is_player_in_area = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		is_player_in_area = false
		Global.run_speed = original_run_speed # Reset to original run speed when player leaves the area

func _physics_process(delta):
	if is_player_in_area:
		for body in $Area2D.get_overlapping_bodies():
			if body is CharacterBody2D:
				# If the player isn't moving, move them at the Global.run_speed in the direction of the wind
				if body.velocity.x == 0:
					body.velocity.x = Global.run_speed * wind_direction
				else:
					# Apply the wind effect in the direction of the wind
					if sign(body.velocity.x) == wind_direction:
						if body.is_on_floor():
							Global.run_speed = original_run_speed + ground_wind_speed
						else:
							Global.run_speed = original_run_speed + air_wind_speed
						body.velocity.x += Global.run_speed * delta # Increase the player's velocity when moving with the wind
					else:
						Global.run_speed = original_run_speed - ground_wind_speed
					body.velocity.x = Global.run_speed * wind_direction

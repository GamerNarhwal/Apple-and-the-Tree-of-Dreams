extends CharacterBody2D
class_name Player

@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D3  # Replace "Sprite2D3" with the actual name of your Sprite2D node
@onready var climb_detector = $ClimbDetector

# Constants
const JUMP_VELOCITY = -100.0

# Signals
signal direction_changed(new_direction)

# Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_non_zero_direction = 1
var can_climb:bool = false
var is_climbing:bool = false
var jump_timer: float = 0.0
const JUMP_GRACE_PERIOD: float = 0.2  # Adjust as needed

func _ready():
	print("Player ready")

func _enter_tree():
	Global.playerStartPosition = position
	Global.currentCheckPoint = Global.playerStartPosition
	position = Global.playerStartPosition

func update_animation(direction):
	if direction != 0:
		animations.play("move_right")
	else:
		animations.pause()
		animations.seek(0)

func _physics_process(delta):
	if not Global.isPaused:
		var direction = Input.get_axis("ui_left", "ui_right")
		
		# Check if player is in a climbable area
		can_climb = _is_in_climbable_area()
		
		# Handle animations
		update_animation(direction)
		
		# Decrement jump timer
		if jump_timer > 0:
			jump_timer -= delta
		
		# Handle climbing
		if can_climb and jump_timer <= 0:
			if Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
				is_climbing = true
				if Input.is_action_pressed("ui_up"):
					velocity.y = -Global.climb_speed * delta
				elif Input.is_action_pressed("ui_down"):
					velocity.y = Global.climb_speed * delta
			else:
				is_climbing = true
				velocity.y = 0
		else:
			is_climbing = false
		
		# Apply gravity when not climbing
		if not is_on_floor() and not is_climbing:
			velocity.y += Global.gravity_scale * delta
		
		# Handle jump
		if Input.is_action_just_pressed("ui_jump"):
			if is_on_floor() or Global.is_in_water or can_climb:
				velocity.y = Global.jump_force * delta
				is_climbing = false
				jump_timer = JUMP_GRACE_PERIOD
				
				# Apply horizontal boost if jumping off a climbable surface and moving
				if can_climb and direction != 0:
					velocity.x = direction * Global.jump_boost * delta
		
		# Handle horizontal movement
		if direction != 0:
			velocity.x = direction * Global.run_speed * delta
			last_non_zero_direction = direction
		else:
			# Gradually reduce velocity when not moving
			if !Global.isWindy and not is_climbing:
				velocity.x = lerp(velocity.x, 0.0, 0.2)
			elif is_climbing:
				velocity.x = 0
		
		# Flip sprite based on movement direction
		sprite.flip_h = last_non_zero_direction < 0
		Global.last_non_zero_direction = last_non_zero_direction
		
		# Move the player
		move_and_slide()
		
		# Emit direction changed signal
		emit_signal("direction_changed", last_non_zero_direction)

func _is_in_climbable_area() -> bool:
	var overlapping_areas = climb_detector.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("ClimbableAreas"):
			return true
	return false

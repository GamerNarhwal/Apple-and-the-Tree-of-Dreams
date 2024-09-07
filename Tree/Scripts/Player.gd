extends CharacterBody2D
class_name Player

# Nodes
@onready var animations = $AnimationPlayer
@onready var sprite = $Sprite2D3  # Replace "Sprite2D" with the actual name of your Sprite2D node
@onready var climb_detector = $ClimbDetector

# Constants
const JUMP_VELOCITY = -100.0
const JUMP_GRACE_PERIOD: float = 0.2  # Adjust as needed
const CLIMB_FALL_DELAY: float = 3.0   # Time in seconds before the player starts to fall when not pressing up or down

# Signals
signal direction_changed(new_direction)

# Variables
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var last_non_zero_direction = 1
var in_climbable_area: bool = false
var is_climbing: bool = false
var climb_fall_timer: float = 1.0

func _ready():
	add_to_group("Player")

# Called when the node is added to the scene tree
func _enter_tree():
	Global.playerStartPosition = position
	Global.currentCheckPoint = Global.playerStartPosition
	position = Global.playerStartPosition

# Update the player's animation based on movement direction
func update_animation(direction: float) -> void:
	if direction != 0:
		animations.play("move_right")
	else:
		animations.pause()
		animations.seek(0)

# Main physics processing loop
func _physics_process(delta: float) -> void:
	if not Global.isPaused:
		var direction = Input.get_axis("ui_left", "ui_right")
		
		# Check if player is in a climbable area
		in_climbable_area = _is_in_climbable_area()
		
		# Handle animations
		update_animation(direction)
		
		# Handle climbing
		_handle_climbing(delta)
		
		# Handle jump
		_handle_jump(direction, delta)
		
		# Apply gravity when not climbing
		if not is_on_floor() and not is_climbing:
			velocity.y += gravity * delta
		
		# Handle horizontal movement
		_handle_horizontal_movement(direction, delta)
		
		# Flip sprite based on movement direction
		sprite.flip_h = last_non_zero_direction < 0
		Global.last_non_zero_direction = last_non_zero_direction
		
		# Move the player
		move_and_slide()
		
		# Emit direction changed signal
		emit_signal("direction_changed", last_non_zero_direction)

# Check if the player is in a climbable area
func _is_in_climbable_area() -> bool:
	var overlapping_areas = climb_detector.get_overlapping_areas()
	for area in overlapping_areas:
		if area.is_in_group("ClimbableAreas"):
			return true
	return false

# Handle the climbing logic
func _handle_climbing(delta: float) -> void:
	if in_climbable_area:
		if not is_climbing and (Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")):
			is_climbing = true
		
		if is_climbing:
			if Input.is_action_pressed("ui_up"):
				velocity.y = -Global.climb_speed * delta
				climb_fall_timer = CLIMB_FALL_DELAY
			elif Input.is_action_pressed("ui_down"):
				velocity.y = Global.climb_speed * delta
				climb_fall_timer = CLIMB_FALL_DELAY
			else:
				if climb_fall_timer > 0:
					velocity.y = 0
					climb_fall_timer -= delta
				else:
					velocity.y += gravity * delta * 0.5  # Slow fall when the timer expires
	else:
		is_climbing = false

# Handle the jumping logic
func _handle_jump(direction: float, delta: float) -> void:
	if Input.is_action_just_pressed("ui_jump"):
		if is_on_floor() or Global.is_in_water or in_climbable_area:
			velocity.y = Global.jump_force * delta
			is_climbing = false
			
			# Apply horizontal boost if jumping off a climbable surface and moving
			if in_climbable_area and direction != 0:
				velocity.x = direction * Global.jump_boost * delta

# Handle horizontal movement logic
func _handle_horizontal_movement(direction: float, delta: float) -> void:
	if direction != 0:
		velocity.x = direction * Global.run_speed * delta
		last_non_zero_direction = direction
	else:
		# Gradually reduce velocity when not moving
		if not Global.isWindy:
			velocity.x = lerp(velocity.x, 0.0, 0.2)
	
	# If climbing, reduce horizontal speed
	if is_climbing:
		velocity.x *= 0.5  # You can adjust this value to control horizontal speed while climbing

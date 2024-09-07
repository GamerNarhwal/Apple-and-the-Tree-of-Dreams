extends RigidBody2D

var push_strength: float = 5000.0
var lift_strength: float = 7000.0
var slope_factor: float = 1.2

@onready var ray_left: RayCast2D = $RayLeft
@onready var ray_right: RayCast2D = $RayRight
@onready var ray_beneath: RayCast2D = $RayBottom

func _ready():
	lock_rotation = true
	gravity_scale = 1.0
	linear_damp = 1.0

func _physics_process(delta):
	handle_push(delta)

func handle_push(delta):
	var push_vector = Vector2.ZERO
	
	# Horizontal push
	if ray_left.is_colliding() and ray_left.get_collider().is_in_group("Player"):
		if Input.is_action_pressed("ui_right"):
			push_vector.x = 1
	elif ray_right.is_colliding() and ray_right.get_collider().is_in_group("Player"):
		if Input.is_action_pressed("ui_left"):
			push_vector.x = -1
	
	# Vertical lift only if player is directly beneath and jumps
	if ray_beneath.is_colliding() and ray_beneath.get_collider().is_in_group("Player"):
		if Input.is_action_just_pressed("ui_jump"):
			push_vector.y = -1
	
	# Apply force if there's any push input
	if push_vector != Vector2.ZERO:
		var force = calculate_force(push_vector)
		apply_central_impulse(force * delta)

func calculate_force(push_vector: Vector2) -> Vector2:
	var force = Vector2.ZERO
	
	# Adjust force for horizontal movement based on slope detection
	if push_vector.x != 0:
		force.x = push_vector.x * push_strength
		
		# Adjust the force if the object is on a slope
		if ray_left.is_colliding() and ray_right.is_colliding():
			var angle = 45
			if angle != 0:
				# Apply slope factor to horizontal force
				force.x *= cos(angle) * slope_factor
				# Compensate for gravity along the slope
				force.y -= sin(angle) * push_strength
	
	# Apply vertical lift force
	if push_vector.y < 0:
		force.y = -lift_strength
	
	return force



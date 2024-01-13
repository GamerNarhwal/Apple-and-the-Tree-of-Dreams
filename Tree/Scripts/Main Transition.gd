extends Camera2D

var speed = 100.0  # Speed of the movement
var target_position = Vector2(545.0, 320.0)  # Target position to move to

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(545.0, 320.0) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = target_position - position  # Direction to the target
	if direction.length() > speed * delta:  # If we are not yet at the target
		direction = direction.normalized() * speed * delta  # Move towards the target
	else:
		direction = target_position - position  # Move directly to the target
	position += direction

func _on_start_game_pressed():
	target_position = Vector2(545.0, 950.0)  # Set the target position when the button is pressed

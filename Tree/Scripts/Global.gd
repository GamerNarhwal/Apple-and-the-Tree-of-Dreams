extends Node

var level = [
	"res://Levels/Main Scen.tscn",
	"res://Levels/Level 1-1.tscn", 
	"res://Levels/Level 1-2.tscn", 
	"res://Levels/Level 1-3.tscn",
	"res://Levels/Level 1-4.tscn",
	"res://Levels/Level 2-1.tscn",
	"res://Levels/Level 2-2.tscn",
	"res://Levels/Level 2-3.tscn",
	"res://Levels/Level 2-4.tscn",
	"res://Levels/Level 3-1.tscn",
	"res://Levels/Level 3-2.tscn",
	"res://Levels/Level 3-3.tscn",
	"res://Levels/Level 3-4.tscn",
	"res://Levels/Level 4-1.tscn",
	"res://Levels/Level 4-2.tscn",
	"res://Levels/Level 4-3.tscn",
	"res://Levels/Level 4-4.tscn"
]

#set this up on an individual scale for each world, design some world lock system

var current_level = 1

var playerStartPosition = Vector2()
var currentCheckPoint = Vector2()

var isPaused = false
var atExit = false
var is_in_menu = false

var furthestLevel = 1

var run_speed = 450
var jump_force = -1000.0 
var gravity_scale = ProjectSettings.get_setting("physics/2d/default_gravity")

var last_non_zero_direction

var isWindy
var is_in_water = false




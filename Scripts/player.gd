extends CharacterBody2D

@onready var animated_sprite := $AnimatedSprite2D
@onready var hitbox := $CollisionShape2D

var left_pressed := false
var right_pressed := false

var look_direction := 1

@export var wall_jump_force := Vector2(300, -400)
@export var max_wall_jumps := 1
var wall_jumps_remaining := max_wall_jumps
var is_wall_sliding := false

@export var coyote_time_duration := 0.125
var coyote_time_remaining := 0.0

# Variables used in player states
var left := -1
var right := 1
var neutral := 0

var walk_speed := 100
var sprint_speed := 200
var sneak_speed := 45

var jump_speed := -300
var fall_speed := 980 # aka gravity
var wall_slide_speed := 100

var no_movement := 0

var player = PlayerState.new()

func movement(delta):
	var move_up = Input.is_action_just_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	var move_fast = Input.is_action_pressed("move_fast")
	var left_right_movement = Input.get_axis("move_left","move_right")
	player.direction = left_right_movement
	do_horizontal_movement(player, move_down, move_fast)

func _physics_process(delta):
	var is_grounded := is_on_floor()
	var is_touching_wall := is_on_wall()
	
	if is_grounded:
		coyote_time_remaining = coyote_time_duration
		wall_jumps_remaining = max_wall_jumps
	else:
		coyote_time_remaining -= delta
	
	movement(delta)
	print(velocity)
	# JUMPING LOGIC TODO
	#TODO: NEED TO TRACK WHEN THE PLAYER IS IN THE AIR AND DEPENDING ON + or - VELOCITY PLAY Animation
	#TODO: make a big priority tree on what takes what priority when certain things effect the player, like idle, falling, moving, etc
	
	is_wall_sliding = false
	if is_touching_wall and not is_grounded and velocity.y > 0:
		is_wall_sliding = true
		velocity.y = min(velocity.y, wall_slide_speed)
		
		var collision = get_last_slide_collision()
		if collision:
			var wall_normal = collision.get_normal()
			if wall_normal.x < 0:
				velocity.x += 1
				animated_sprite.rotation_degrees = -90
				hitbox.rotation_degrees -90
			elif wall_normal.x > 0:
				velocity.x -= 1
				animated_sprite.rotation_degrees = 90
				hitbox.rotation_degrees = 90
	else:
		animated_sprite.rotation_degrees = 0
	
	move_and_slide()
	
func do_horizontal_movement(playerstate: PlayerState, move_down, move_fast):
	if move_down:
		velocity.x = playerstate.direction * sneak_speed
	elif move_fast:
		velocity.x = playerstate.direction * sprint_speed
	else:
		velocity.x = playerstate.direction * walk_speed

func get_wall_jump_direction() -> int:
	if is_on_wall():
		var collision = get_last_slide_collision()
		if collision:
			if collision.get_normal().x > 0:
				return -1
			elif collision.get_normal().x < 0:
				return 1
	return 0


func _on_button_pressed():
	pass # Replace with function body.

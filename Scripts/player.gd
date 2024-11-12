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

# Setting up player states
var idle_ps := PlayerState.new(neutral, no_movement, no_movement, "idle")
var sneak_ps := PlayerState.new(neutral, no_movement, no_movement, "sneak")

var jump_ps := PlayerState.new(neutral, no_movement, jump_speed, "jump")
var fall_ps := PlayerState.new(neutral, no_movement, fall_speed, "fall")
var wall_slide_ps := PlayerState.new(neutral, no_movement, wall_slide_speed, "wall_slide")

var left_walk_ps := PlayerState.new(left, walk_speed, no_movement, "walk")
var left_sprint_ps := PlayerState.new(left, sprint_speed, no_movement, "sprint")
var left_sneak_ps := PlayerState.new(left, sneak_speed, no_movement, "sneak")
var right_walk_ps := PlayerState.new(right, walk_speed, no_movement, "walk")
var right_sprint_ps := PlayerState.new(right, sprint_speed, no_movement, "sprint")
var right_sneak_ps := PlayerState.new(right, sneak_speed, no_movement, "sneak")



func movement(delta):
	var move_up = Input.is_action_just_pressed("move_up")
	var move_down = Input.is_action_pressed("move_down")
	var move_fast = Input.is_action_pressed("move_fast")
	var left_right_movement = Input.get_axis("move_left","move_right")
	if left_right_movement == left:
		do_left_movement(move_fast, move_down)
	elif left_right_movement == right:
		do_right_movement(move_fast, move_down)
	elif is_on_floor():
		do_movement(idle_ps)
	if move_up:
		velocity.y = jump_ps.vertical_speed
		animated_sprite.play(jump_ps.animation)
		animated_sprite.flip_h = look_direction > 0
	elif !is_on_floor():
		velocity.y += fall_ps.vertical_speed * delta
		animated_sprite.play(fall_ps.animation)
		animated_sprite.flip_h = look_direction > 0

func _physics_process(delta):
	var is_grounded := is_on_floor()
	var is_touching_wall := is_on_wall()
	
	if is_grounded:
		coyote_time_remaining = coyote_time_duration
		wall_jumps_remaining = max_wall_jumps
	else:
		coyote_time_remaining -= delta
	
	movement(delta)
	
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
	
func do_movement(playerstate: PlayerState):
	velocity.x = playerstate.direction * playerstate.horizontal_speed
	animated_sprite.play(playerstate.animation)
	look_direction = playerstate.direction
	if playerstate.animation != "idle":
		animated_sprite.flip_h = playerstate.direction > 0
	

func do_right_movement(move_fast, move_down):
	if move_fast:
		do_movement(right_sprint_ps)
	elif move_down:
		do_movement(right_sneak_ps)
	else:
		do_movement(right_walk_ps)

func do_left_movement(move_fast, move_down):
	if move_fast:
		do_movement(left_sprint_ps)
	elif move_down:
		do_movement(left_sneak_ps)
	else:
		do_movement(left_walk_ps)
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

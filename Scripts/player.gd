extends CharacterBody2D

@export var speed := 100
@export var gravity := 980
@export var jump_force := -300
@export var sprint_multiplier := 2
var left_pressed = false
var right_pressed = false
var last_direction_pressed = 0

var wall_slide_speed := 100
@export var wall_jump_force := Vector2(300, -400)
@export var max_wall_jumps := 1
var wall_jumps_remaining := max_wall_jumps
var is_wall_sliding := false

@export var coyote_time_duration := 0.125
var coyote_time_remaining := 0.0

@onready var animated_sprite := $AnimatedSprite2D


# Setting up player states
var idle_ps := PlayerState.new(0, 0, 0, "idle")

var jump_ps := PlayerState.new(0, 0, -100, "jump")
var fall_ps := PlayerState.new(0, 0, 100, "fall")
var wall_slide_ps := PlayerState.new(0, 0, wall_slide_speed, "wall_slide")

var left_walk_ps := PlayerState.new(-1, 100, 0, "walk")
var left_sprint_ps := PlayerState.new(-1, 100, 0, "walk")
var left_sneak_ps := PlayerState.new
var right_walk_ps := PlayerState.new
var right_sprint_ps := PlayerState.new
var right_sneak_ps := PlayerState.new









func _ready():
	animated_sprite.play("idle")
	
func _input(event):
	if event.is_action_pressed("move_left"):
		left_pressed = true
		last_direction_pressed = -1
	if event.is_action_pressed("move_right"):
		right_pressed = true
		last_direction_pressed = 1
	if event.is_action_released("move_left"):
		left_pressed = false
		if right_pressed:
			last_direction_pressed = 1
		else:
			last_direction_pressed = 0
	if event.is_action_released("move_right"):
		right_pressed = false
		if left_pressed:
			last_direction_pressed = -1
		else:
			last_direction_pressed = 0

func _physics_process(delta):
	var is_grounded := is_on_floor()
	var is_touching_wall := is_on_wall()
	
	if is_grounded:
		coyote_time_remaining = coyote_time_duration
		wall_jumps_remaining = max_wall_jumps
	else:
		coyote_time_remaining -= delta
	
	var direction = last_direction_pressed
	
	var sprint := Input.is_action_pressed("move_fast")
	var jump := Input.is_action_just_pressed("move_up")
	
	var current_speed := speed
	if sprint and direction != 0:
		current_speed *= sprint_multiplier
	
	velocity.x = direction * current_speed
	
	is_wall_sliding = false
	if is_touching_wall and not is_grounded and velocity.y > 0:
		is_wall_sliding = true
		velocity.y = min(velocity.y, wall_slide_speed)
		
		var collision = get_last_slide_collision()
		if collision:
			var wall_normal = collision.get_normal()
			if wall_normal.x < 0:
				animated_sprite.rotation_degrees = -90
			elif wall_normal.x > 0:
				animated_sprite.rotation_degrees = 90
	else:
		animated_sprite.rotation_degrees = 0
	
	if jump:
		if coyote_time_remaining > 0.0:
			velocity.y = jump_force
			coyote_time_remaining = 0.0
		elif is_wall_sliding and wall_jumps_remaining > 0:
			velocity.y = wall_jump_force.y
			velocity.x = wall_jumps_remaining * get_wall_jump_direction()
			wall_jumps_remaining -= 1
			is_wall_sliding = false
		animated_sprite.play("jump")
	
	if direction != 0 and not jump:
		animated_sprite.play("walk")
		animated_sprite.flip_h = direction > 0
	elif not jump:
		animated_sprite.play("idle")
	
	if not is_grounded and not is_wall_sliding:
		velocity.y += gravity * delta
	
	move_and_slide()
	
func get_wall_jump_direction() -> int:
	if is_on_wall():
		var collision = get_last_slide_collision()
		if collision:
			if collision.get_normal().x > 0:
				return -1
			elif collision.get_normal().x < 0:
				return 1
	return 0

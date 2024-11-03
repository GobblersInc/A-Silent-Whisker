extends CharacterBody2D

@export var speed := 100
@export var sneak_speed := 45
@export var gravity := 980
@export var jump_force := -300
@export var sprint_multiplier := 2
var left_pressed = false
var right_pressed = false
var last_direction_pressed = 0

@export var wall_slide_speed := 100
@export var wall_jump_force := Vector2(300, -400)
@export var max_wall_jumps := 1
var wall_jumps_remaining := max_wall_jumps
var is_wall_sliding := false

@export var coyote_time_duration := 0.123
var coyote_time_remaining := 0.0

@onready var animated_sprite := $AnimatedSprite2D

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
	var sneak := Input.is_action_pressed("move_down")
	
	var current_speed := speed
	if sprint and direction != 0:
		current_speed *= sprint_multiplier
		
	if sneak and direction != 0:
		current_speed = sneak_speed
	
	# WALL SLIDING LOGIC + ANIMATION TRIGGER
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
	
	# JUMP LOGIC (GROUND AND WALL + COYOTE TIME)
	if jump:
		if coyote_time_remaining > 0.0:
			velocity.y = jump_force
			coyote_time_remaining = 0.0
		elif is_wall_sliding and wall_jumps_remaining > 0:
			velocity.y = wall_jump_force.y
			direction = get_wall_jump_direction()
			wall_jumps_remaining -= 1
			is_wall_sliding = false
	
	# APPLYING ANIMATION 
	if direction != 0:
		if sneak:
			animated_sprite.play("sneak")
		else:
			animated_sprite.play("walk")
		animated_sprite.flip_h = direction > 0
	else:
		if sneak:
			animated_sprite.play("sneak")
		else:
			animated_sprite.play("idle")
	
	# GRAVITY CALCULATION
	if not is_grounded and not is_wall_sliding:
		velocity.y += gravity * delta
	
	# APPLIES THE MOVEMENT VELOCITY
	velocity.x = direction * current_speed
	
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

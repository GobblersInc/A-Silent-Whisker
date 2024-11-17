extends CharacterBody2D

@onready var animated_sprite := $AnimatedSprite2D
@onready var hitbox := $CollisionShape2D
@onready var weather: Node = $WeatherControlNode

@export var max_wall_jumps := 1
var wall_jumps_remaining := max_wall_jumps
var is_wall_sliding := false
var inverted: bool = false
var jeb: bool = false

@export var coyote_time_duration := 0.125
var coyote_time_remaining := 0.0

# Variables used in player states
var left := -1
var right := 1
var neutral := 0

var walk_speed := 100
var sprint_speed := 200
var sneak_speed := 45

var jump_speed := -200
var wall_jump_speed := -300
var fall_speed := 980 # aka gravity
var wall_slide_speed := 100

var no_movement := 0

var player = PlayerState.new()

var jump_time := 0.0
var max_hop := .2

var last_moved_direction := 0

func _physics_process(delta):
	var is_grounded := is_on_floor()
	var is_touching_wall := is_on_wall()
	
	if is_grounded:
		coyote_time_remaining = coyote_time_duration
		wall_jumps_remaining = max_wall_jumps
		jump_time = 0.0
	else:
		coyote_time_remaining -= delta
	
	movement()
	
	floor_jumping(delta)
	
	is_wall_sliding = false
	if is_touching_wall and not is_grounded and velocity.y > 0:
		velocity.x = last_moved_direction
		is_wall_sliding = true
		velocity.y = min(velocity.y, wall_slide_speed)
		if wall_jumps_remaining > 0:
			wall_jumping()
	
	animate()
	
	move_and_slide()

func movement():
	var move_down = Input.is_action_pressed("move_down")
	var move_fast = Input.is_action_pressed("move_fast")
	if inverted == false:
		var left_right_movement = Input.get_axis("move_left","move_right")
		player.direction = left_right_movement
	else:
		var left_right_movement = Input.get_axis("move_right","move_left")
		player.direction = left_right_movement
	if player.direction != 0:
		last_moved_direction = player.direction
		if move_down:
			velocity.x = player.direction * sneak_speed
			player.animation = "sneak"
			hitbox.transform
		elif move_fast:
			velocity.x = player.direction * sprint_speed
			player.animation = "sprint"
		else:
			velocity.x = player.direction * walk_speed
			player.animation = "walk"
	elif is_on_floor():
		velocity.x = player.direction * walk_speed
		if move_down:
			player.animation = "crouch"
		else:
			player.animation = "idle"
	if velocity.x > 0 and !move_down and !move_fast:
		velocity.x = walk_speed
	elif velocity.x < 0 and !move_down and !move_fast:
		velocity.x = -walk_speed
	if velocity.x > 0:
		if weather.wind_effect.amount_ratio == 1:
			velocity.x *= 0.5
	if velocity.x < 0:
		if weather.wind_effect.amount_ratio == 1:
			velocity.x *= 1.5

func floor_jumping(delta):
	var move_up = Input.is_action_pressed("move_up")
	if move_up and jump_time < max_hop and coyote_time_remaining > 0:
		jump_time += delta
		velocity.y = jump_speed
	elif Input.is_action_just_released("move_up"):
		jump_time = 9999
	elif !is_on_floor():
		velocity.y += fall_speed * delta

func wall_jumping():
	var wall_move_up = Input.is_action_just_pressed("move_up")
	if wall_move_up:
		velocity.y = wall_jump_speed
		wall_jumps_remaining -= 1

func animate():
	if jeb == true:
		animated_sprite.flip_v = true
	
	if is_on_floor():
		animated_sprite.play(player.animation)
	
	if velocity.y < 0:
		animated_sprite.play("jump")
	elif velocity.y > 0:
		if is_on_wall():
			animated_sprite.play("wall_slide")
		elif !is_on_wall():
			animated_sprite.play("fall")
		
	if velocity.x > 0:
		animated_sprite.flip_h = true
	elif velocity.x < 0:
		animated_sprite.flip_h = false

extends CharacterBody2D

@export var speed := 100
@export var gravity := 980
@export var jump_force := -300
@export var sprint_multiplier := 2

@export var coyote_time_duration := 0.125
var coyote_time_remaining := 0.0

@onready var animated_sprite := $AnimatedSprite2D

func _ready():
	animated_sprite.play("idle")

func _physics_process(delta):
	var is_grounded := is_on_floor()
	
	if is_grounded:
		coyote_time_remaining = coyote_time_duration
	else:
		coyote_time_remaining -= delta
	
	if Input.is_action_just_pressed("move_up") and coyote_time_remaining > 0.0:
		velocity.y = jump_force
		coyote_time_remaining = 0.0
	
	if not is_grounded:
		velocity.y += gravity * delta
	
	var direction := 0
	
	var sprint := Input.is_action_pressed("move_fast")
	var right := Input.is_action_pressed("move_right")
	var left := Input.is_action_pressed("move_left")
	
	if right and not left:
		direction = 1
	elif left and not right:
		direction = -1
		
	var current_speed := speed
	if sprint and direction != 0:
		current_speed *= sprint_multiplier
	
	velocity.x = direction * current_speed
	
	if direction != 0:
		animated_sprite.play("walk")
		animated_sprite.flip_h = direction > 0
	else:
		animated_sprite.play("idle")

	
	move_and_slide()
	

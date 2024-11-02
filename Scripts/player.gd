extends CharacterBody2D

@export var speed := 400
@export var gravity := 980
@export var jump_force := -300


func _ready():
	pass 


func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity * delta
	else:
		if Input.is_action_just_pressed("move_up"):
			velocity.y = jump_force
	
	var direction := 0
	if Input.is_action_pressed("move_right"):
		direction += 1
	elif Input.is_action_pressed("move_left"):
		direction -= 1
		
	velocity.x = direction * speed
	
	move_and_slide()

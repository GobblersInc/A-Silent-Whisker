extends Area2D

@export var id: int # For history tracking purposes
@export var destination_dialog: Array # For dialog box to tell player where to go
@export var destination: String # Tracks to see if you are talking to the right person
@export var contents_dialog: Array # For when the player deliveres the letter, the recipent will read out some lines giving some semblence of story

var is_collected: bool = false # Also history tracking purposes

func _ready():
	connect("body_entered", _on_body_entered(self))

func _on_body_entered(body):
	if body.name == "player" and not is_collected:
		is_collected = true
		# add to player inventory function
		queue_free()

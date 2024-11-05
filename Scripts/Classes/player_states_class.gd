extends Object

class_name PlayerState 

var direction: int = 0 # 0 for not moving, -1 for left, 1 for right
var horizontal_speed: int = 0 # Numbers will be all positive
var vertical_speed: int = 0 # Numbers can dip into negative depending on jump/fall
var animation: String = "idle" # String correlates with the different animations in AnimatedSprite2D

func _init(dir: int, hor_sp: int, ver_sp: int, ani: String) -> void:
	direction = dir
	horizontal_speed = hor_sp
	vertical_speed = ver_sp
	animation = ani

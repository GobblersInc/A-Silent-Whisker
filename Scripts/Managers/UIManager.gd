extends Control

@onready var _OptionsScreen = $OptionsControl
@onready var _Player = $Player
# Called when the node enters the scene tree for the first time.
func _ready():
	_OptionsScreen.hide()

func _Pause():
	print("The Pause Button HAS BEEN PRESSED!!!")
	get_tree().set_pause(true)
	_OptionsScreen.show()
	
func _Unpause():
	print("The Unpause Button HAS BEEN PRESSED!!!")
	get_tree().set_pause(false) 
	_OptionsScreen.hide()
	
#func _on_button_pressed():
	#if (get_tree().is_paused()):
		#_Pause()
	#else:
		#_Unpause()
		#if (!get_tree().is_paused()):
		#get_tree().set_pause(true)
		#_OptionsScreen.show()
	#else:
		#get_tree().set_pause(false)
		#_OptionsScreen.hide()

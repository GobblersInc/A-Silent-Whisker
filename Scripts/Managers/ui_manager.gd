extends Control

@onready var _OptionsScreen = $OptionsControl

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
	

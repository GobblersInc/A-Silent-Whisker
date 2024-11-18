extends Node

# Signals for different types of input
signal move_left_right(direction: float)
signal move_down(state: bool)
signal move_fast(state: bool)
signal move_up(state: bool)
signal jump_pressed()
signal jump_released()
signal test_action()
var paralyzed = false

@onready var dialog_manager = get_node("/root/DialogManager")
signal benis(state, text)

# Store input states
var inverted = false

func _ready() -> void:
    dialog_manager.connect("dialog_update", _on_dialog_update)

func _on_dialog_update(state, _text):
    paralyzed = state

func _process(_delta):
    # Detect "test" action and emit signal
    if Input.is_action_just_pressed("test"):
        if paralyzed:
            benis.emit(false, "")
        else:
            benis.emit(true, "IDK")
    # Detect horizontal movement and emit signal
    if paralyzed:
        move_left_right.emit(0)
        move_up.emit(false)
    else:
        var left_right_movement = Input.get_axis("move_left", "move_right") if not inverted else Input.get_axis("move_right", "move_left")
        move_left_right.emit(left_right_movement)
        
        # Detect "move_down" and emit signal
        var down = Input.is_action_pressed("move_down")
        move_down.emit(down)
        
        # Detect "move_fast" and emit signal
        var fast = Input.is_action_pressed("move_fast")
        move_fast.emit(fast)
        
        # Detect "move_up" and emit signals for pressed/released states
        var up = Input.is_action_pressed("move_up")
        move_up.emit(up)
        if Input.is_action_just_pressed("move_up"):
            jump_pressed.emit()
        if Input.is_action_just_released("move_up"):
            jump_released.emit()

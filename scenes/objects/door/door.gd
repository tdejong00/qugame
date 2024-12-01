## A door which can be opened and closed.
## The door opens by sliding up and closes instantly.
class_name Door extends Node3D

signal door_opened
signal door_closed

## Whether the door can be opened.
@export var active: bool = true

## Whether the door is open or closed.
var is_open: bool = false

@onready var _animation_player: AnimationPlayer = $CharacterBody3D/AnimationPlayer


## Opens the door.
func open():
    if active:
        door_opened.emit()
        _animation_player.play("open")
        await _animation_player.animation_finished
        is_open = true


## Closes the door.
func close():
    door_closed.emit()
    _animation_player.play_backwards("open")
    await _animation_player.animation_finished
    is_open = false

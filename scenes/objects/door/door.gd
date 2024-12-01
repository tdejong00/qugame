## A door which can be opened and closed.
## The door opens by sliding up and closes instantly.
class_name Door extends Node3D

signal door_opened
signal door_closed

## Whether the door can be opened.
@export var active: bool = false

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
    _animation_player.stop()
    _animation_player.seek(0.0)
    door_closed.emit()
    is_open = false

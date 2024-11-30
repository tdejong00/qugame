## A door which can be opened and closed.
## The door opens by sliding up and closes instantly.
class_name Door extends Node3D

## Whether the door is open or not.
var is_open: bool = false

@onready var _animation_player: AnimationPlayer = $CharacterBody3D/AnimationPlayer


## Opens the door.
func open():
    _animation_player.play("open")
    await _animation_player.animation_finished
    is_open = true


## Closes the door.
func close():
    _animation_player.stop()
    _animation_player.seek(0.0)
    is_open = false

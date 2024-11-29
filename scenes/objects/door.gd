## TODO
class_name Door extends Node3D

@onready var animation_player: AnimationPlayer = $CharacterBody3D/AnimationPlayer


## Opens the door.
func open():
    animation_player.play("open")


## Closes the door.
func close():
    animation_player.stop()
    animation_player.seek(0.0)

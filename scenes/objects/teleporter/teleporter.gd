## A teleportation device, which switches to a specified
## scene when the player interacts with it.
class_name Teleporter extends Interactable

## The scene to switch to when the teleporter is activated.
@export var next_scene: PackedScene


func _ready() -> void:
    interaction_text = "Press [F] to teleport"


## Handles interaction by changing to the specified scene.
func interact(key: String) -> void:
    super.interact(key)
    if key == "F":
        SignalBus.fade_out.emit(next_scene)

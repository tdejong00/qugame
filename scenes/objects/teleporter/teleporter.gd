## A teleportation device, which switches to a specified
## scene when the player interacts with it.
class_name Teleporter extends Interactable

## The scene to switch to when the teleporter is activated.
@export var next_scene: PackedScene

var _player: Player

func _ready() -> void:
    _player = get_tree().get_first_node_in_group("player")
    interaction_text = "Press [F] to teleport"


func _on_fade_out_finished(anim_name: String) -> void:
    if anim_name == "fade_out":
        get_tree().change_scene_to_packed(next_scene)


## Handles interaction by changing to the specified scene.
func interact(key: String) -> void:
    super.interact(key)

    if key == "F":
        _player.ui.animation_player.play("fade_out")
        _player.ui.animation_player.connect("animation_finished", _on_fade_out_finished)

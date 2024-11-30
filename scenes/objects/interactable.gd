## Represents an interactable object in the game world.
class_name Interactable extends Node3D

## Whether the interactable can be interacted with.
@export var active: bool = false
## Interaction radius of the interactable area.
@export_range(0.0, 100.0) var interaction_radius: float = 2.0
## Whether the level should be advanced when interacting with this interactable.
@export var advances_level: bool = false
## Text which will be displayed while interactable.
var interaction_text: String = "Press [F] to interact."

var area: Area3D
var collision_shape: CollisionShape3D


func _enter_tree() -> void:
    if not active:
        return

    # Create Area3D node
    area = Area3D.new()
    add_child(area)

    # Create spherical CollisionShape3D node with specified radius
    var shape = SphereShape3D.new()
    shape.radius = interaction_radius
    collision_shape = CollisionShape3D.new()
    collision_shape.shape = shape
    area.add_child(collision_shape)


## Called when the interactable object is activated.
func interact(key: String) -> void:
    if advances_level:
        advances_level = false
        SignalBus.advance_level.emit()

## Represents an interactable object in the game world.
class_name Interactable extends Node3D

## Whether the interactable can be interacted with.
@export var active: bool = false
## interaction_radius of the interactable area.
@export_range(0.0, 100.0) var interaction_radius: float = 2.0
## Text which will be displayed while interactable.
@export var interaction_text: String = "Press [F] to interact."

var area: Area3D
var collision_shape: CollisionShape3D


func _enter_tree() -> void:
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
    pass

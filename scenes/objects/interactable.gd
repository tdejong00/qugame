## Represents an interactable object in the game world.
class_name Interactable extends Node3D

## Whether the interactable can be interacted with.
@export var active: bool = false : set = _set_active
## Interaction radius of the interactable _area.
@export_range(0.0, 100.0) var interaction_radius: float = 2.0

## Text which will be displayed while interactable.
var interaction_text: String = "Press [F] to interact."

var _area: Area3D
var _collision_shape: CollisionShape3D


func _init() -> void:
    # Create Area3D node
    _area = Area3D.new()
    _area.collision_layer = 2
    _area.collision_mask = 4
    _area.body_entered.connect(_on_body_entered)
    _area.body_exited.connect(_on_body_exited)

    # Create spherical CollisionShape3D node with specified radius
    var shape = SphereShape3D.new()
    shape.radius = interaction_radius
    _collision_shape = CollisionShape3D.new()
    _collision_shape.shape = shape


## Called when the interactable object is activated.
func interact(key: String) -> void:
    pass


## Activates or de-activates the interactable area.
func _set_active(value: bool) -> void:
    if (value):
        add_child(_area)
        _area.add_child(_collision_shape)
    else:
        _area.remove_child(_collision_shape)
        remove_child(_area)
        SignalBus.interactable_area_exited.emit(self)


func _on_body_entered(body: Node3D) -> void:
    SignalBus.interactable_area_entered.emit(self)


func _on_body_exited(body: Node3D) -> void:
    SignalBus.interactable_area_exited.emit(self)

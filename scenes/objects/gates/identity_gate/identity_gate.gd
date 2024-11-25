## Represents an identity quantum gate.
class_name IdentityGate extends QuantumGate

## Resource path for creating instances of the scene.
const SCENE: PackedScene = preload("res://scenes/objects/gates/identity_gate/identity_gate.tscn")


func _init() -> void:
    _matrix = [
        Vector2(1.0, 0.0), Vector2(0.0, 0.0),
        Vector2(0.0, 0.0), Vector2(1.0, 0.0)
    ]

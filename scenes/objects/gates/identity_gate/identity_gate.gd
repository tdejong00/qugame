## Represents an identity quantum gate.
class_name IdentityGate extends QuantumGate


func _init() -> void:
    _matrix = [
        Vector2(1.0, 0.0), Vector2(0.0, 0.0),
        Vector2(0.0, 0.0), Vector2(1.0, 0.0)
    ]

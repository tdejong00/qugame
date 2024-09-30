## Represents an identity quantum gate, which leaves the state of the qubit unchanged.
class_name IdentityGate extends QuantumGate


func _init() -> void:
    _matrix = [
        1.0, 0.0,
        0.0, 1.0
    ]

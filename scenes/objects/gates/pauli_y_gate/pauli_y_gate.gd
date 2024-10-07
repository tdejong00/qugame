## Represents a Pauli-Y quantum gate.
class_name PauliYGate extends QuantumGate


func _init() -> void:
    _matrix = [
        Vector2(0.0, 0.0), Vector2(0.0, -1.0),
        Vector2(0.0, 1.0), Vector2(0.0, 0.0)
    ]
